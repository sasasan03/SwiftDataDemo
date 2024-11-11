//
//  ShopRowView.swift
//  SwiftDataDemo
//
//  Created by sako0602 on 2024/10/27.
//

import SwiftUI
import SwiftData

struct GoodsView: View {
    
    @Bindable var shop: Shop
    @State private var showAddModal = false
    @State private var selectedGoods: Goods?
    @State private var goodsName = ""
    @State private var isError = false
    let imageFileManager = ImageFileManager()
    
    var body: some View {
        List {
            AddGoodRowView()
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .onTapGesture {
                    showAddModal = true
                }
            ForEach(shop.goodsList) { good in
                GoodRowView(shop: shop, goods: good)
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedGoods = good
                    }
            }
            .onDelete(perform: deleteGoods)
        }
        .listStyle(.grouped)
        .sheet(item: $selectedGoods) { selectedGood in //タップされたグッズの編集のシートを開く
            GoodsSheetView(shop: shop ,goods: selectedGood) { saveGoods in
//                if let index = shop.goodsList.firstIndex(where: { $0 == selectedGood }) {
//                    // 画像の保存を行う。どこに保存したのかのURLが欲しい
//                    let imagePathURL = imageFileManager.editGoodsImage(shop: shop,selectedGood: selectedGood ,image: saveGoods.image!)
//                    let goods = Goods(name: saveGoods.name, price: saveGoods.price, imagePathURL: imagePathURL)
//                    shop.goodsList[index] = goods
//                } else {
//                    isError = true
//                }
            }
        }
        .sheet(isPresented: $showAddModal){ //新しくグッズをついかするためのシートを開く
            GoodsSheetView(shop: shop, goods: nil) { saveGoods in
                guard let image = saveGoods.image else { fatalError("imageがnil") }
                let strGoodsURL = imageFileManager.saveGoodsImage(shopName: shop.name, goodsName: saveGoods.name, uiImage: image)
                let goods = Goods(name: saveGoods.name, price: saveGoods.price, imagePathURL: strGoodsURL)
                shop.goodsList.append(goods)
            }
        }
        .navigationTitle("『\(shop.name)』編集画面")
        .alert(isPresented: $isError, error: ShopError.matchingGoodError) {
            Button("OK"){
                isError = false
            }
        }
    }
    
    private func deleteGoods(at offsets: IndexSet) {
        shop.goodsList.remove(atOffsets: offsets)
    }
    
}


// 追加された商品の雛形
private struct GoodRowView: View {
    
    let imageFileManager = ImageFileManager()
    let shop: Shop
    let goods: Goods?
    
    var body: some View {
        HStack{
            if let goods {
                //画像
                let goodUiImage = imageFileManager.loadGoodsImage(shopName: shop.name, goodsName: goods.name)
                Image(uiImage: goodUiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                
                //グッズの名前
                VStack {
                    Spacer()//🍔縦中央寄せ
                    HStack {
                        Text(goods.name)
                        Spacer()//名前を左に寄せる
                        Text("\(goods.price)円")
                    }//下線
                    Spacer()//🍔縦中央寄せ
                }
                Spacer()
            } else {
                Text("グッズを追加してください")
            }
        }
    }
}


// List上部にあるショップモーダルを表示させるためのボタン
private struct AddGoodRowView: View {
    var body: some View {
        HStack{
            Image(systemName: "plus.square.dashed")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.red,.orange)
                .frame(width: 50, height: 50)
            VStack {
                Spacer()//🍔中央寄せ
                HStack {
                    Text("グッズを追加する...")
                        .foregroundStyle(.red)
                    Spacer()//名前を左に寄せる
                }//下線
                Spacer()//🍔中央寄せ
            }
            Spacer()
        }
    }
}


//#Preview {
//    GoodsView(shop: .constant(Shop(name: "ナイキ", imageData: nil, goods: [])))
//}
