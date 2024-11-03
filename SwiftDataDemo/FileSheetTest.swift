//
//  FileSheetTest.swift
//  SwiftDataDemo
//
//  Created by sako0602 on 2024/11/03.
//

import SwiftUI

struct FileSheetTest: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var shopName = ""
    @State private var selectedImage: UIImage?
    @State private var isPickerPresented = false
    let filePathManager = FilePathManager()
    let saveShopData: (String, String) -> Void
    
    var body: some View {
        NavigationStack {
            VStack{
                //画像が選ばれたときと、選ばれなかった時のパターンを考えたかった。
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
                TextField("お店の名前を入力してください。", text: $shopName)
                    .textFieldStyle(.roundedBorder)
                    .padding()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    // もしも、写真が選ばれたら、その写真を保存し、選ばれなかった場合はデフォルトの画像を用意する。
                    Button("追加"){
                        dismiss()
                        guard !shopName.isEmpty else { return print("#お店の名前を入力してください") }
                        if let selectedImage {
                            guard let imageData = selectedImage.jpegData(compressionQuality: 0.8) else {
                                fatalError("画像をデータへ変換するのに失敗")
                            }
                            //ファイルへ画像の保存と、pathのStringを取得する
                            let path = filePathManager.writingToFile(shopName: shopName, data: imageData)
                            saveShopData(shopName,path)
                        } else {
                            guard let defultImage = UIImage(systemName: "photo")?.jpegData(compressionQuality: 0.8) else { fatalError("defaltImageがありません") }
                            saveShopData(shopName, "")
                        }
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("キャンセル")
                            .foregroundStyle(.red)
                    }

                }
            }
            .sheet(isPresented: $isPickerPresented) {
                PhotoPicker(selectedImage: $selectedImage)
            }
        }
    }

}
//
//#Preview {
//    FileSheetTest()
//}
