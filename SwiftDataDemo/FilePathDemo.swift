//
//  FilePathDemo.swift
//  SwiftDataDemo
//
//  Created by sako0602 on 2024/11/02.
//

import SwiftUI

struct FilePathDemo: View {
    
    var body: some View {
        Button("実行") {
            self.writingToFile(text: "SwiftDataの実験")
            
            print("【ファイル内容】\(self.readFromFile())")
        }
    }
    
    //　書き込み
    func writingToFile(text: String) {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("フォルダURL取得エラー")
        }
        
        let fileURL = documentsURL.appendingPathComponent("output.txt")
        
        do {
            try text.write(to: fileURL, atomically: true, encoding: .utf8)
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

#Preview {
    FilePathDemo()
}
