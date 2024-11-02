//
//  ShopView.swift
//  SwiftDataDemo
//
//  Created by sako0602 on 2024/10/25.

////追加ボタンがタップされたタイミングでTextFieldの中身を空にする
//.onChange(of: shopName) { oldValue, _ in
//    shopName = oldValue
//}

import SwiftUI
import SwiftData

struct ShopView: View {
    
    @Environment(\.modelContext) var context
    @Query private var savedShopList:[Shop] = []
    @State private var path: [Shop] = []
    @State private var shopList:[Shop] = []// 表示と編集のためのプロパティ
    @State private var showAddShopView = false
    @State private var isError = false

    
    var body: some View {
        NavigationStack(path: $path) {
            //OnDeleteを使用するためにList使てる
            List {
                // 上部の一つだけ変わったセル
                AddShopRowView()
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showAddShopView = true
                    }
                // 上部一つ以外
                ForEach(shopList){ shop in
                    NavigationLink(value: shop) {
                        ShopRowView(shop: shop)
                    }
                }
                .onDelete(perform: deleteItem)
            }
            .listStyle(.grouped) //変わった感じのListでおもろそうだったので使ってみた。
            .navigationTitle("お店一覧")
            .navigationDestination(for:  Shop.self, destination: { shop in
                GoodsView(shop: .constant(shop))
            })
            
        }
        .onAppear {
            //アプリ立ち上げ時に、保存したデータを編集するためのプロパティへ代入
            shopList = savedShopList
        }
        .sheet(isPresented: $showAddShopView) {
            // 新しく作成するお店（名前とデータ）をもらってきて保存する。
            AddShopSheetView() { shopName, shopImage in
                let shop = Shop(name: shopName, imageData: shopImage, goods: [])
                context.insert(shop) //SwiftDataへ追加
                shopList.append(shop) //編集のためのListへ追加
                do {
                    try context.save()
                    // 新しいお店をSwiftDataへ保存し、商品を追加するためのViewへ遷移させる。
                    path.append(shop)
                } catch {
                    isError = true
                }
            }
        }
        .alert(isPresented: $isError, error: ShopError.saveDataError) {
            Button("OK"){
                isError = false
            }
        }

    }
    
    private func deleteItem(at offsets: IndexSet) {
        for index in offsets {
            let selectedItem = savedShopList[index]
            context.delete(selectedItem)
            shopList.remove(atOffsets: offsets)
        }
        try? context.save()
    }
    
}

// 追加されたお店の雛形
private struct ShopRowView: View {
    let shop: Shop?
    var body: some View {
        HStack{
            //画像
            if let imageData = shop?.imageData {
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
            //お店の名前
            VStack {
                Spacer()//🍔中央寄せ
                HStack {
                    if let shopName = shop?.name {
                        Text(shopName)
                    } else {
                        Text("ショップ名なし（エラー）")
                    }
                    Spacer()//名前を左に寄せる
                }//下線
                Spacer()//🍔中央寄せ
            }
            Spacer()
        }
    }
}

// List上部にあるショップモーダルを表示させるためのボタン
private struct AddShopRowView: View {
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
                    Button {
                        
                    } label: {
                        Text("ショップを追加する...")
                            .foregroundStyle(.red)
                    }
                    Spacer()//名前を左に寄せる
                }//下線
                Spacer()//🍔中央寄せ
            }
            Spacer()
        }
    }
}

#Preview {
    ShopView()
        .modelContainer(for: [Shop.self])
}
