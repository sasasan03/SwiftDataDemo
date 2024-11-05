//
//  AddShopSheetView.swift
//  SwiftDataDemo
//
//  Created by sako0602 on 2024/10/30.
//

import SwiftUI

// 新規のお店を追加するためのView
struct ShopSheetView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var shopName = "" //TODO: パスが重複してしまうと、書き込み取り出しができなくなるのでバリデーション処理を追加する
    @State private var selectedImage: UIImage?
    @State private var isPickerPresented = false
    let imageFileManager = ImageFileManager()
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
                        guard !shopName.isEmpty else { fatalError("ドキュメントがない") }
                        if let selectedImage {
                            let imageURL = imageFileManager.writingToFile(shopID: shopName, uiImage: selectedImage)
                            saveShopData(shopName,imageURL)
                            
                        } else {
                            let photoImage = UIImage(systemName: "photo")!//確実に存在する画像
                            let defaultImageURL = imageFileManager.writingToFile(shopID: shopName, uiImage: photoImage)
                            saveShopData(shopName, defaultImageURL)
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



//#Preview {
//    AddShopSheetView(saveShopData: (String, Data) -> Void)
//}
