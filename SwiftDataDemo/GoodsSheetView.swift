//
//  GoodSheetView.swift
//  SwiftDataDemo
//
//  Created by sako0602 on 2024/11/02.
//

import SwiftUI

// グッズの修正か追加を行うためのシート
struct GoodsSheetView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var goodsName = ""
    @State private var goodsPrice = ""
    @State private var selectedImage: UIImage?
    @State private var isPickerPresented = false
    let goods: Goods?
    let saveGoods: (Goods) -> Void
    
    init(goods: Goods?, saveGood:  @escaping (Goods) -> Void ){
        //初期化タイミングでどちらの追加か編集かを決定する。
        if let goods {
            goodsName = goods.name
            goodsPrice = String(goods.price)
            if let imageData = goods.imageData {
                selectedImage = UIImage(data: imageData)
            } else {
                selectedImage = UIImage(systemName: "photo")
            }
        }
        self.goods = goods
        self.saveGoods = saveGood
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if let goods { //グッズ編集画面(すでに画像、名前、金額を持っている)
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
                    TextField(goods.name, text: $goodsName)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 250)
                        .padding()
                    TextField(String(goods.price), text: $goodsPrice)
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
                        TextField("グッズを入力してください。", text: $goodsName)
                            .textFieldStyle(.roundedBorder)
                            .multilineTextAlignment(.trailing)
                        Text("")
                            .frame(width: 30)
                    }
                    HStack {
                        Text("金額")
                            .font(.headline)
                            .frame(width: 80)
                        TextField("金額を入力してください。", text: $goodsPrice)
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
                        let goodPrice = Int(goodsPrice) ?? 0
                        let goods = Goods(name: goodsName, price: goodPrice, imageData: selectImage)
                        saveGoods(goods)
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
