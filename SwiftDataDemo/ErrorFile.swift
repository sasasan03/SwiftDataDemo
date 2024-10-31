//
//  ErrorFile.swift
//  SwiftDataDemo
//
//  Created by sako0602 on 2024/10/31.
//

import Foundation

enum ShopError: LocalizedError {
    case saveDataError
    
    var errorDescription: String? {
        switch self {
        case .saveDataError:
            return "データの保存に失敗しました。"
        }
    }
}
