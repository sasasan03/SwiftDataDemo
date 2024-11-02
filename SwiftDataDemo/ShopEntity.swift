//
//  ShopEntity.swift
//  SwiftDataDemo
//
//  Created by sako0602 on 2024/10/27.
//

import Foundation
import SwiftData

//お店
@Model
class Shop: Identifiable {
    var id = UUID()
    var name: String
    var imageData: Data?
    var goods: [Good]
    
    init(name: String, imageData: Data? ,goods: [Good]) {
        self.name = name
        self.imageData = imageData
        self.goods = goods
    }
}

//お店にある商品
@Model
class Good: Identifiable {
    var id = UUID()
    var name: String
    var price: Int
    var imageData: Data?
    init(name: String, price: Int, imageData: Data?) {
        self.name = name
        self.price = price
        self.imageData = imageData
    }
}
