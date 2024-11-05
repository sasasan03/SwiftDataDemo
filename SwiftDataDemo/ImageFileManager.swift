//
//  FilePathManager.swift
//  SwiftDataDemo
//
//  Created by sako0602 on 2024/11/02.
//

import Foundation
import SwiftUI

struct ImageFileManager {
    
    //　書き込み
    func writingToFile(shopName: String,uiImage: UIImage) -> String {
        guard let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("ドキュメントがない")
        }
        
        //ドキュメントURLにファイルの名前を繋げる
        let fileURL = documentURL.appendingPathComponent(shopName)
        
        //画像をデータへ変換
        let jpegImageData = uiImage.jpegData(compressionQuality: 0.8)
        
        do {
            // ファイルにjpegのデータを書き込む
            try jpegImageData!.write(to: fileURL, options: .atomic)
        } catch {
            print("#Error:\(error)")
        }
        print("🍔ファイルパス",fileURL.absoluteString)
        return fileURL.absoluteString
    }
    
    // 読みこみ
    func readFromFile(shopName: String) -> UIImage {
        //documentURLを取得する
        do {
            // ドキュメントのURLを取得する
            guard let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                fatalError("フォルダURL取得エラー")
            }
            
            //取得してきたいファイルのURLを取得する
            let fileURL = documentURL.appendingPathComponent(shopName)
            
            //取得してきたURL型をData型へ変換する
            let imageData = try Data(contentsOf: fileURL)
            
            //
            guard let uiImage = UIImage(data: imageData) else {
                fatalError("データを画像へ変換するのに失敗しました。")
            }
            
            return uiImage
        } catch {
            fatalError("画像データの生成に失敗しました")
        }
    }
    
    
    func getShopDirectory(for shopName: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let shopURL = documentsURL.appendingPathComponent(shopName)
        
        // ディレクトリが存在しない場合は作成
        if !fileManager.fileExists(atPath: shopURL.path) {
            do {
                try fileManager.createDirectory(at: shopURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Failed to create shop directory: \(error)")
                return nil
            }
        }
        return shopURL
    }
    
    func saveGoodsImageToShopDirectory(_ image: UIImage, fileName: String, shopName: String) -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.8),
              let shopURL = getShopDirectory(for: shopName) else {
            return nil
        }
        
        let fileURL = shopURL.appendingPathComponent(fileName)
        
        do {
            try imageData.write(to: fileURL)
            return fileURL.lastPathComponent  // ファイル名を返す
        } catch {
            print("Failed to save image to shop directory: \(error)")
            return nil
        }
    }
    
}
