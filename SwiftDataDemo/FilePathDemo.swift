//
//  FilePathDemo.swift
//  SwiftDataDemo
//
//  Created by sako0602 on 2024/11/02.
//

import SwiftUI

struct FilePathDemo: View {
    
    @State private var showSheet = false
    @State private var selectedImage: UIImage?
    @State private var isPickerPresented = false
    @State private var shopList:[SampleShop] = []// 表示と編集のためのプロパティ
    let filePathManager = FilePathManager()
    
    var body: some View {
        
        VStack {
            if let selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.blue)
                    .frame(width: 200, height: 200)
                    .onTapGesture {
                        isPickerPresented = true
                    }
            } else {
                Image(systemName: "photo.badge.plus")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.blue)
                    .frame(width: 200, height: 200)
                    .onTapGesture {
                        isPickerPresented = true
                    }
            }
            Button("実行") {
                showSheet = true
                print("【ファイル内容】\(self.readFromFile())")
            }
        }
        .sheet(isPresented: $showSheet) {
            FileSheetTest { shopName, path in
                let sampleShop = SampleShop(name: shopName, imagePathURL: path, goods: [])
                let image = filePathManager.readFromFile(shopName: shopName)
                selectedImage = image
                shopList.append(sampleShop)
            }
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
