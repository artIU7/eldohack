//
//  ProductCategory.swift
//  ScannerPrice
//
//  Created by Артем Стратиенко on 22.06.2021.
//

import Foundation

struct Product {
    let name:String?
    let price:String?
    let data:String?
}
class ProductAPI {
    static func getContacts() -> [Product]{
        let products = [
            Product(name: "Смартфон Honor 30S 128GB Neon Purple (CDY-NX9A)", price: "23990", data: "ЭльдоSALE"),
            Product(name: "Смартфон Honor 30S 128GB Neon Purple (CDY-NX9A)", price: "23990", data: "ЭльдоSALE"),
            Product(name: "Смартфон Honor 30S 128GB Neon Purple (CDY-NX9A)", price: "23990", data: "ЭльдоSALE")
        ]
        return products
    }
}
