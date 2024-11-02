//
//  GoodSheetView.swift
//  SwiftDataDemo
//
//  Created by sako0602 on 2024/11/02.
//

import SwiftUI

// グッズの修正か追加を行うためのシート
struct GoodSheetView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var goodName = ""
    @State private var goodPrice = ""
    @State private var selectedImage: UIImage?
    @State private var isPickerPresented = false
    let good: Good?
    let saveGood: (Good) -> Void
    
    init(good: Good?, saveGood:  @escaping (Good) -> Void ){
        //初期化タイミングでどちらの追加か編集かを決定する。
        if let good {
            goodName = good.name
            goodPrice = String(good.price)
            if let imageData = good.imageData {
                selectedImage = UIImage(data: imageData)
            } else {
                selectedImage = UIImage(systemName: "photo")
            }
        }
        self.good = good
        self.saveGood = saveGood
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if let good { //グッズ編集画面(すでに画像、名前、金額を持っている)
                    if let selectedImage {
                        Image(uiImage:  selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .onTapGesture {
                                isPickerPresented = true
                            }
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.blue)
                            .frame(width: 200, height: 200)
                            .onTapGesture {
                                isPickerPresented = true
                            }
                    }
                    TextField(good.name, text: $goodName)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 250)
                        .padding()
                    TextField(String(good.price), text: $goodPrice)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 250)
                        .padding()
                } else { //グッズ追加画面
                    if let selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.blue)
                            .frame(width: 250, height: 250)
                            .onTapGesture {
                                isPickerPresented = true
                            }
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.blue)
                            .frame(width: 250, height: 250)
                            .onTapGesture {
                                isPickerPresented = true
                            }
                    }
                    
                    HStack {
                        Text("グッズ名")
                            .font(.headline)
                            .frame(width: 80)
                        TextField("グッズを入力してください。", text: $goodName)
                            .textFieldStyle(.roundedBorder)
                            .multilineTextAlignment(.trailing)
                        Text("")
                            .frame(width: 30)
                    }
                    HStack {
                        Text("金額")
                            .font(.headline)
                            .frame(width: 80)
                        TextField("金額を入力してください。", text: $goodPrice)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                        Text("円")
                            .font(.subheadline)
                            .frame(width: 30, alignment: .leading)
                    }
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("キャンセル")
                            .foregroundStyle(.red)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    // TODO: エラー処理
                    Button { //入力したデータを前のViewへ渡して保存してもらう
                        let selectImage = selectedImage?.jpegData(compressionQuality: 1.0)
                        let goodPrice = Int(goodPrice) ?? 0
                        let good = Good(name: goodName, price: goodPrice, imageData: selectImage)
                        saveGood(good)
                        dismiss()
                    } label: {
                        Text("保存")
                    }
                    
                }
            }
            .sheet(isPresented: $isPickerPresented) {
                PhotoPicker(selectedImage: $selectedImage)
            }
        }
    }
}
