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
    var products = [Product]()
    func addProduct(eldoProduct : eldoCatalog) {
        products.append(Product(name: eldoProduct.title, price: String(eldoProduct.price), data: eldoProduct.sale))
    }
    func getContacts() -> [Product]{
        return self.products
    }
}
