//
//  FilePathManager.swift
//  SwiftDataDemo
//
//  Created by sako0602 on 2024/11/02.
//

import Foundation
import SwiftUI

struct FilePathManager {
    
    //　書き込み
    func writingToFile(shop: Shop, text: String) {
        guard let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("フォルダURL取得エラー")
        }
        
        //保存する画像の名前
        let fileName: String? = "\(String(describing: shop.imageData))"
        
        let fileURL = documentURL.appendingPathComponent(fileName!)
        
        //TODO: 強制アンラップを修正
        let jpegImageData = UIImage(data: shop.imageData!)!.jpegData(compressionQuality: 0.8)
        
        do {
            try jpegImageData!.write(to: fileURL, options: .atomic)
        } catch {
            print("#Error:\(error)")
        }
    }
    
    // 読みこみ
    func readFromFile() -> String {
        
        guard let dirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("フォルダURL取得エラー")
        }
        
        let fileURL = dirURL.appendingPathComponent("output.txt")
        
        guard let fileContnts = try? String(contentsOf: fileURL) else {
            fatalError("ファイルの読み込みエラー")
        }
        
        return fileContnts
        
    }

    
}

