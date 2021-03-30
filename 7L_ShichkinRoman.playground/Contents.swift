//1. Придумать класс, методы которого могут завершаться неудачей и возвращать либо значение, либо ошибку Error?. Реализовать их вызов и обработать результат метода при помощи конструкции if let, или guard let.
//
//2. Придумать класс, методы которого могут выбрасывать ошибки. Реализуйте несколько throws-функций. Вызовите их и обработайте результат вызова при помощи конструкции try/catch.
import UIKit
import Foundation

class Eatery {
    var menu = [
        "Burger" : 100,
        "Soda" : 50,
        "Fries" : 70
    ]
    func howMuch(position: String) -> Int? {
        return menu[position]
    }
}

// MARK: - guard let
let a = Eatery()
a.howMuch(position: "Burger")
a.howMuch(position: "Meat")


struct Item {
    let product: Product
    var price: Int
    var diameter: Int
}

struct Product{
    let name: String
}

class Pizzeria {
    var menu = [
        "Peperoni small": Item(product: Product(name: "Пепперони маленькая"), price: 400, diameter: 30),
        "Peperoni big": Item(product: Product(name: "Пепперони большая"), price: 500, diameter: 38),
        "Cheesy": Item(product: Product(name: "Сырная"), price: 350, diameter: 30),
        "Chicken-boom": Item(product: Product(name: "Чикен-бум"), price: 0, diameter: 40)
    ]
    
    var moneyDeposited = 0
    
    func vend(itemNamed name: String) -> (Product?, PizzeriaError?) {
        guard let item = menu[name] else {
            return (nil, PizzeriaError.invalidSelection)
        }
        guard item.price <= moneyDeposited else {
            return (nil, PizzeriaError.notEnoughMoney(moneyNeeded: item.price - moneyDeposited))
        }
        moneyDeposited -= item.price
        let newItem = item
        return (newItem.product, nil)
    }
}

enum PizzeriaError: Error {
    case invalidSelection
    case notEnoughMoney(moneyNeeded: Int)
    
    var localizedDescription: String {
        switch self {
        case .invalidSelection:
            return "Нет в ассортименте"
        case .notEnoughMoney(moneyNeeded: let moneyNeeded):
            return "Недостаточно денег: \(moneyNeeded)"
        }
    }
}

var pizza = Pizzeria()
let buy1 = pizza.vend(itemNamed: "Cheesy")
let buy2 = pizza.vend(itemNamed: "Chicken-boom")

if let product = buy1.0 {
    print("Мы купили: \(product.name)")
} else if let error = buy1.1 {
    print("Произошла ошибка: \(error.localizedDescription)")
}

if let product = buy2.0 {
    print("Мы купили: \(product.name)")
} else if let error = buy2.1 {
    print("Произошла ошибка: \(error.localizedDescription)")
}

// MARK: - Try/Catch

extension Pizzeria {
    
    func correctVend(itemNamed name: String) throws -> Product {
        guard let item = menu[name] else {
            throw PizzeriaError.invalidSelection
        }
        guard item.price <= moneyDeposited else {
            throw PizzeriaError.notEnoughMoney(moneyNeeded: item.price - moneyDeposited)
        }
        moneyDeposited -= item.price
        let newItem = item
        menu[name] = newItem
        return newItem.product
    }
}

do {
    let sell = try pizza.correctVend(itemNamed: "Cheesy-boom")
    print("Мы купили: \(sell.name)")
    
} catch PizzeriaError.invalidSelection {
    print("Такой пиццы в меню не существует")
    
} catch PizzeriaError.notEnoughMoney(let moneyNeeded) {
    print("Денег недостаточно. Необходимо еще \(moneyNeeded)")
    
} catch let error {
    print(error)
}

do {
    let sell1 = try pizza.correctVend(itemNamed: "Peperoni small")
    print("Мы купили: \(sell1.name)")
    
} catch PizzeriaError.invalidSelection {
    print("Такой пиццы в меню не существует")
    
} catch PizzeriaError.notEnoughMoney(let moneyNeeded) {
    print("Денег недостаточно. Необходимо еще \(moneyNeeded)")
    
} catch let error {
    print(error)
}

do {
    let sell2 = try pizza.correctVend(itemNamed: "Chicken-boom")
    print("Мы купили: \(sell2.name)")
    
} catch PizzeriaError.invalidSelection {
    print("Такой пиццы в меню не существует")
    
} catch PizzeriaError.notEnoughMoney(let moneyNeeded) {
    print("Денег недостаточно. Необходимо еще \(moneyNeeded)")
    
} catch let error {
    print(error)
}

