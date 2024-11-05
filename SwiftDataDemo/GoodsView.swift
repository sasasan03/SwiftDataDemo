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
    
    var body: some View {
        List {
            AddGoodRowView()
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .onTapGesture {
                    showAddModal = true
                }
            ForEach(shop.goodsList) { good in
                GoodRowView(goods: good)
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
            GoodsSheetView(goods: selectedGood) { saveGood in
                if let index = shop.goodsList.firstIndex(where: { $0 == selectedGood }) {
                    shop.goodsList[index] = saveGood
                } else {
                    isError = true
                }
            }
        }
        .sheet(isPresented: $showAddModal){ //新しくグッズをついかするためのシートを開く
            GoodsSheetView(goods: nil) { goods in
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
    let goods: Goods?
    var body: some View {
        HStack{
            if let goods {
                //画像
                if let imageData = goods.imageData {
                    Image(uiImage: UIImage(data: imageData)!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                }
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
