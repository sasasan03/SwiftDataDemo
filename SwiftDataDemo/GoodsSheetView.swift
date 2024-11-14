//
//  GoodSheetView.swift
//  SwiftDataDemo
//
//  Created by sako0602 on 2024/11/02.
//

import SwiftUI

// グッズの修正か追加を行うためのシート
struct GoodsSheetView: View {
    
    // タプル型に３つも渡すのはわかりにくいかと思い、構造体を作成
    struct SaveGood {
        var name: String
        var price: Int
        var image: UIImage?
    }
    
    @Environment(\.dismiss) private var dismiss
    @State private var goodsName = ""
    @State private var goodsPrice = ""
    @State private var selectedImage: UIImage?
    @State private var isPickerPresented = false
    let imageFileManager = ImageFileManager()
    let shop: Shop
    let goods: Goods?
    let saveGoods: (SaveGood) -> Void
    
    init(shop: Shop ,goods: Goods?, saveGood:  @escaping (SaveGood) -> Void){
        //初期化タイミングでどちらの追加か編集かを決定する。
        if let goods {
            goodsName = goods.name
            goodsPrice = String(goods.price)
            selectedImage = imageFileManager.loadGoodsImage(shopName: shop.name, goodsName: goods.name)
        }
        self.shop = shop
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
                    Button { //入力したデータを前のViewへ渡して保存を行う。
                        let goodPrice = Int(goodsPrice) ?? 0
                        let goodsItem = SaveGood(name: goodsName, price: goodPrice, image: selectedImage)
                        saveGoods(goodsItem)
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
