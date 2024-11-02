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
    @State private var selectedGood: Good?
    @State private var goodName = ""
    @State private var isError = false
    
    var body: some View {
        List {
            AddGoodRowView()
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .onTapGesture {
                    showAddModal = true
                }
            ForEach(shop.goods) { good in
                GoodRowView(good: good)
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedGood = good
                    }
            }
            .onDelete(perform: deleteGood)
        }
        .listStyle(.grouped)
        .sheet(item: $selectedGood) { selectedGood in //タップされたグッズの編集のシートを開く
            GoodSheetView(good: selectedGood) { saveGood in
                if let index = shop.goods.firstIndex(where: { $0 == selectedGood }) {
                    shop.goods[index] = saveGood
                } else {
                    isError = true
                }
            }
        }
        .sheet(isPresented: $showAddModal){ //新しくグッズをついかするためのシートを開く
            GoodSheetView(good: nil) { good in
                shop.goods.append(good)
            }
        }
        .navigationTitle("『\(shop.name)』編集画面")
        .alert(isPresented: $isError, error: ShopError.matchingGoodError) {
            Button("OK"){
                isError = false
            }
        }
    }
    
    private func deleteGood(at offsets: IndexSet) {
        shop.goods.remove(atOffsets: offsets)
    }
    
}


// 追加された商品の雛形
private struct GoodRowView: View {
    let good: Good?
    var body: some View {
        HStack{
            if let good {
                //画像
                if let imageData = good.imageData {
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
                        Text(good.name)
                        Spacer()//名前を左に寄せる
                        Text("\(good.price)円")
                    }//下線
                    Spacer()//🍔縦中央寄せ
                }
                Spacer()
            } else {
                // TODO: エラー
                Text("ももひき")
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
