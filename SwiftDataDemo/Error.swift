//
//  ErrorFile.swift
//  SwiftDataDemo
//
//  Created by sako0602 on 2024/10/31.
//

import Foundation

enum ShopError: LocalizedError {
    case saveDataError
    case matchingGoodError
    
    var errorDescription: String? {
        switch self {
        case .saveDataError:
            return "データの保存に失敗しました。"
        case .matchingGoodError:
            return "書き換えるグッズが見つけられませんでした。"
        }
    }
}

enum ImageFileManagerError: LocalizedError {
    case documentURLNotFound
    case invalidFilePath
    case imageCreationFailed
    case dataConversionFailed
    case shopURLNotFound
    case goodsURLNotFound

    var errorDescription: String? {
        switch self {
        case .documentURLNotFound:
            return "ドキュメントURLが見つかりませんでした。"
        case .invalidFilePath:
            return "無効なファイルパスです。"
        case .imageCreationFailed:
            return "画像の作成に失敗しました。"
        case .dataConversionFailed:
            return "データの画像変換に失敗しました。"
        case .shopURLNotFound:
            return "shopのURLが見つかりませんでした。"
        case .goodsURLNotFound:
            return "goodsのURLが見つかりませんでした。"
        }
    }
}

