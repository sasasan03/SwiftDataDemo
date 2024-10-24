//
//  Item.swift
//  SwiftDataDemo
//
//  Created by sako0602 on 2024/10/21.
//

import Foundation
import SwiftData

//①modelの作成

@Model
class Item: Identifiable {
    var id = UUID()
    var name: String
    init(name: String){
        self.name = name
    }
}
