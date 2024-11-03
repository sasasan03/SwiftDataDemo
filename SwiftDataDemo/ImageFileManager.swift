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
}
