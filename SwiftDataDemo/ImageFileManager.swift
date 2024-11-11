//
//  FilePathManager.swift
//  SwiftDataDemo
//
//  Created by sako0602 on 2024/11/02.
//

import Foundation
import SwiftUI

struct ImageFileManager {
    
    let fileManager = FileManager.default
    
    /// shopのディレクトリのパスを取得
    /// Viewの中で、Shop型で保存するためString。
    func shopURL(shopName: String) -> String {
        guard let documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("documentURLがnil")
        }
        let shopDirectoryURL = documentURL.appendingPathComponent("\(shopName)")
        
        return shopDirectoryURL.absoluteString
    }
    
    ///　ショップの画像書き込み
    func saveShopImage(shopName: String,uiImage: UIImage) {
        
        guard let shopURL = URL(string: shopURL(shopName: shopName)) else { fatalError("ファイルパスが見当たりません") }
        
        do {
            //ディレクトリがなければディレクトリを作成する
            if !fileManager.fileExists(atPath: shopURL.path) {
                try fileManager.createDirectory(at: shopURL,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
            }
            guard let imageData = uiImage.jpegData(compressionQuality: 0.8) else { fatalError("画像の作成に失敗") }
            //拡張子をjpegにしてPathを作る
            let shopImagePath = shopURL.appendingPathComponent("\(shopName).jpeg")
            //書き込む
            try imageData.write(to: shopImagePath)
            print("\(shopImagePath.path) にファイルを保存しました。")
        } catch {
            print("shopエラー: \(error)")
        }

    }
    
    /// ショップの画像読みこみ。UIImageを返す
    func loadShopImage(shopName: String) -> UIImage {
        
        do {
            guard let shopURL = URL(string: shopURL(shopName: shopName)) else { fatalError("URLが見当たらない") }
            
            let shopImagePath = shopURL.appendingPathComponent("\(shopName).jpeg")
            print("#shopImagePath",shopImagePath)
            let imageData = try Data(contentsOf: shopImagePath)
            
            guard let uiImage = UIImage(data: imageData) else {
                fatalError("データを画像へ変換するのに失敗しました。")
            }
            print("#画像をload完了",shopImagePath.path)
            return uiImage
        } catch {
            return UIImage(systemName: "photo")!
        }
    }
    

    
    //グッズの保存を行う
    //①グッズのパスを作成する
    func goodsURL(shopName: String, goodsName: String) -> String {
        guard let documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("documentURLがnil")
        }
        let shopDirectoryURL = documentURL.appendingPathComponent("\(shopName)")
        
        let goodDirectoryURL = shopDirectoryURL.appendingPathComponent("\(goodsName)")

        return goodDirectoryURL.absoluteString
    }
    /// グッズの書き込みを行う。もしも、保存先のディレクトリがない場合は作成して書き込みを行う。
    /// パスのStringを返す。
    func saveGoodsImage(shopName: String, goodsName: String, uiImage: UIImage) -> String {
        
        guard let goodsURL = URL(string: goodsURL(shopName: shopName, goodsName: goodsName)) else { fatalError("グッズのURLが見当たりません") }
        
        do {
            //ディレクトリがなければディレクトリを作成する
            if !fileManager.fileExists(atPath: goodsURL.path) {
                try fileManager.createDirectory(at: goodsURL,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
            }
            guard let imageData = uiImage.jpegData(compressionQuality: 0.8) else { fatalError("画像の作成に失敗") }
            //拡張子をjpegにしてPathを作る
            let goodsImagePath = goodsURL.appendingPathComponent("\(goodsName).jpeg")
            //書き込む
            try imageData.write(to: goodsImagePath)
            print("\(goodsImagePath.path) にファイルを保存しました。")
            return goodsImagePath.absoluteString
        } catch {
            print("エラー: \(error)")
            return "エラー"
        }
    }
    
    //③goodsの画像の読み込みを行う
    /// ショップの画像読みこみ。UIImageを返す
    func loadGoodsImage(shopName: String,goodsName: String) -> UIImage {
        //documentURLを取得する
        do {
            guard let goodsURL = URL(string: goodsURL(shopName: shopName, goodsName: goodsName)) else { fatalError("URLが見当たらない")
            }
            
            let goodsImagePath = goodsURL.appendingPathComponent("\(goodsName).jpeg")
            
            let imageData = try Data(contentsOf: goodsImagePath)

            guard let uiImage = UIImage(data: imageData) else {
                fatalError("データを画像へ変換するのに失敗しました。")
            }
            print("#画像をload完了",goodsURL.path)
            return uiImage
        } catch {
            return UIImage(systemName: "photo")!
        }
    }
    

}

