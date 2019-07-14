//
//  ViewController.swift
//  VendingMachineApp
//
//  Created by 이동영 on 14/07/2019.
//  Copyright © 2019 부엉이. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - UI
    @IBOutlet weak var balence: UILabel!
    @IBOutlet weak var productOut: UIImageView!
    @IBOutlet weak var change: UILabel!
    
    var state: State  = State(money: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func money100(_ sender: Any) {
       handleProcess("100")
    }
    
    @IBAction func money500(_ sender: Any) {
        handleProcess("500")
    }
    
    @IBAction func money1000(_ sender: Any) {
        handleProcess("1000")
    }
    
    @IBAction func selectCola(_ sender: Any) {
        handleProcess("cola")
    }
    
    @IBAction func selectCider(_ sender: Any) {
        handleProcess("cider")
    }
    
    @IBAction func selectFanta(_ sender: Any) {
        handleProcess("fanta")
    }
    
    @IBAction func reset(_ sender: Any) {
        handleProcess("reset")
    }
    
    
    
    // MARK: - Model
    
    
    struct State {
        var money: Int
    }
    
    enum Product: Int {
        case cola = 1000
        case cider = 1200
        case fanta = 1500
        
        var image: UIImage {
            switch self {
            case .cola:
                return UIImage.init(imageLiteralResourceName: "cola_l")
            case .cider:
                return  UIImage.init(imageLiteralResourceName: "cider_l")
            case .fanta:
                return  UIImage.init(imageLiteralResourceName: "fanta_l")
            }
        }
    }
    
    enum Input {
        case inputMoney(Int)
        case selectProduct(Product)
        case reset
        case none
    }
    
    enum Output {
        case displayMoney(Int)
        case productOut(Product)
        case change(Int)
        case shortMoneyError
    }
    
    // MARK: - Logic
    
    lazy var handleProcess = processHandle(State(money:0))
    
    func processHandle(_ initState: State) -> (String) -> Void {
        var state = initState
        return { command in
            state = self.operation(self.uiInput(command), self.uiOutput)(state) }
    }
    
    func uiInput(_ s: String) -> () -> Input {
        
        return {
            switch s {
            case "100":
                return .inputMoney(100)
            case "500":
                return .inputMoney(500)
            case "1000":
                return .inputMoney(1000)
            case "cola":
                return .selectProduct(.cola)
            case "cider":
                return .selectProduct(.cider)
            case "fanta":
                return .selectProduct(.fanta)
            case "reset":
                return .reset
            default:
                return .none
            }
        }
    }
    
    func uiOutput(_ output: Output) -> Void {
        switch output {
        case .change(let money):
            self.change.text = "\(money)"
            DispatchQueue.main.async{
                sleep(1)
                self.change.text = ""
            }
            self.balence.text = "0"
        case .displayMoney(let money):
            self.balence.text = "\(money)"
        case .productOut(let p):
            balence.text = "\(state.money)"
            productOut.image = p.image
            DispatchQueue.main.async {
                sleep(1)
                self.productOut.image = nil
            }
        case .shortMoneyError:
            self.change.text = "잔액이 부족합니다."
            DispatchQueue.main.async {
                sleep(1)
                self.change.text = ""
            }
        }
    }
    
    func operation(_ inp: @escaping () -> Input, _ out: @escaping (Output) -> Void) -> (State) -> State {
        return {
            state in
            switch inp() {
            case .inputMoney(let m):
                let m2 = state.money + m
                out(.displayMoney(m2))
                return State.init(money: m2)
            case .selectProduct(let p):
                if state.money >= p.rawValue {
                    let m2 = state.money - p.rawValue
                    self.state.money = m2
                    out(.displayMoney(m2))
                    out(.productOut(p))
                    return State.init(money: m2)
                }
                else {
                    out(.shortMoneyError)
                    return state
                }
            case .reset:
                out(.change(state.money))
                return State.init(money: 0)
            case .none:
                return state
            }
            
        }
    }
}

