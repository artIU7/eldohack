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
            Product(name: "Honor", price: "20990", data: "22.02.21"),
            Product(name: "Samsung", price: "49500", data: "19.10.21"),
            Product(name: "iPhone", price: "95000", data: "32.03.21"),
            Product(name: "Honor", price: "20990", data: "22.02.21"),
            Product(name: "Samsung", price: "49500", data: "19.10.21"),
            Product(name: "iPhone", price: "95000", data: "32.03.21"),
            Product(name: "Honor", price: "20990", data: "22.02.21"),
            Product(name: "Samsung", price: "49500", data: "19.10.21"),
            Product(name: "iPhone", price: "95000", data: "32.03.21"),
            Product(name: "Honor", price: "20990", data: "22.02.21"),
            Product(name: "Samsung", price: "49500", data: "19.10.21"),
            Product(name: "iPhone", price: "95000", data: "32.03.21"),
        ]
        return products
    }
}
