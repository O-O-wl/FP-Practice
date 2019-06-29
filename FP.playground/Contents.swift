import UIKit

///========================
///        non - FP
///========================

//var i = 1
//while i <= 100 {
//    if i % 3 == 0 && i % 5 == 0 {
//        print("fizz buzz")
//    }
//    else if i % 3 == 0 {
//        print("fizz")
//    }
//    else if i % 5 == 0 {
//        print("buzz")
//    }
//    else {
//        print(i)
//    }
//
//    i += 1
//}

///========================
///           1
///========================
//
//func fizz(_ n: Int) -> String {
//    return n % 3 == 0 ? "fizz" : ""
//}
//func buzz(_ n: Int) -> String {
//    return n % 5 == 0 ? "buzz" : ""
//}
//
//func fizzbuzz(_ n: Int) -> String {
//    let result = fizz(n) + buzz(n)
//    return result.isEmpty ? "\(n)" : result
//}
//
//var i = 0
//while i <= 100 {
//    let output = fizzbuzz(i)
//    print(output)
//    i+=1
//}

///========================
///          2
///========================
func fizz(_ n: Int) -> String {
    return n % 3 == 0 ? "fizz" : ""
}
func buzz(_ n: Int) -> String {
    return n % 5 == 0 ? "buzz" : ""
}

func fizzbuzz(_ n: Int) -> String {
    let result = fizz(n) + buzz(n)
    return result.isEmpty ? "\(n)" : result
}

func loop(times: Int, do f:(Int) -> (Void)) {
    for i in 0...times {
        f(i)
    }
}

loop(times: 100) {
    i in
    let result = fizzbuzz(i)
    print(result)
}
