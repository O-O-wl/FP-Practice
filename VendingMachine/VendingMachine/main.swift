//
//  main.swift
//  VendingMachine
//
//  Created by 이동영 on 14/07/2019.
//  Copyright © 2019 부엉이. All rights reserved.
//

import Foundation

enum Product: Int {
    case cola = 1000
    case milk = 1300
    case coffee = 4500
    
    var name: String {
        switch self {
        case .cola:
            return "콜라🥤"
        case .milk:
            return "우유🥛"
        case .coffee:
            return "커피☕️"
        }
    }
}

enum Input {
    case moneyInput(Int)
    case productSelect(Product)
    case reset
    case none
}

enum Output {
    case displayMoney(Int)
    case productOut(Product)
    case change(Int)
    case shortMoneyError
}

func consoleInput() -> Input {
    guard let command = readLine() else {
        return .none
    }
    switch command {
    case "100": return .moneyInput(100)
    case "500": return .moneyInput(500)
    case "1000": return .moneyInput(1000)
    case "cola": return .productSelect(.cola)
    case "milk": return .productSelect(.milk)
    case "coffee": return .productSelect(.coffee)
    case "reset": return .reset
    default: return .none
    }
    
}

func consoleOutput(_ output: Output) {
    switch output {
    case .displayMoney(let money):
        print("현재 남은 금액은 \(money)입니다.")
    case .productOut(let product):
        print("\(product.name)가 나왔습니다.")
    case .change(let change):
        print("잔액\(change)원이 나왔습니다.")
    case .shortMoneyError:
        print("잔액이 부족합니다.")
    }
}

struct State {
    var money: Int
}

var state = State(money: 0)


func operation(_ inp: @escaping () -> Input, _ out: @escaping (Output) -> ()) -> (State) -> State {
    
    let result: (State) -> State = {
        state in
        switch inp() {
        case .moneyInput(let money):
            let money = state.money + money
            out(.displayMoney(money))
            return State(money: money)
        case .productSelect(let product):
            if state.money > product.rawValue {
                out(.productOut(product))
                let money = state.money - product.rawValue
                out(.displayMoney(money))
                return State(money: money)
            }
            else {
                out(.shortMoneyError)
                return state
            }
        case .reset:
            out(.change(state.money))
            out(.displayMoney(0))
            return State(money: 0)
        case .none:
            return state
        }
    }
    
    return result
}

func machineLoop(_ f: @escaping (State) -> State ) {
    func loop(_ s: State) {
        loop(f(s))
    }
    loop(State(money: 0))
}

machineLoop(operation(consoleInput,consoleOutput))
