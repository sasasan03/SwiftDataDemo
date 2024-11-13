//
//  ShopView.swift
//  SwiftDataDemo
//
//  Created by sako0602 on 2024/10/25.

import SwiftUI
import SwiftData

struct ShopView: View {
    
//    https://www.hackingwithswift.com/quick-start/swiftdata/how-to-use-mvvm-to-separate-swiftdata-from-your-views
//    var number: [Int] {
//    get {
//        // カスタムのゲッター
//        return numberData
//    }
//    set {
//        // カスタムのセッター
//        numberData = newValue
//    }
//}
    
    @Environment(\.modelContext) var context
    @Query private var savedShopList:[Shop] = []//get_onlyのプロパティ
    @State private var path: [Shop] = []
    @State private var shopList:[Shop] = []// 表示と編集のためのプロパティ。コンピューテッドプロパティにする。
    @State private var showAddShopView = false
    @State private var isError = false
    let imageFileManager = ImageFileManager()
    
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
                .onDelete(perform: deleteShop)
            }
            .listStyle(.grouped)
            .navigationTitle("お店一覧")
            .navigationDestination(for:  Shop.self, destination: { shop in
                GoodsView(shop: shop)
            })
        }
        .onAppear {
            //アプリ立ち上げ時に、保存したデータを編集するためのプロパティへ代入
            shopList = savedShopList
        }
        .sheet(isPresented: $showAddShopView) {
            // 新しく作成するお店（名前とデータ）をもらってきて保存する。
            ShopSheetView() { shopName, uiImage in
                //イメージを保存するためのパスを取得（shopの型へ入れるため）
                do {
                    let imagePathURL = try imageFileManager.shopURL(shopName: shopName)
                    //sheetから受け取った画像をアプリ内に保存する
                    let _ = imageFileManager.saveShopImage(shopName: shopName, uiImage: uiImage)
                    let shop = Shop(name: shopName, imagePathURL: imagePathURL, goods: [])
                    context.insert(shop)
                    shopList.append(shop)
                    // 新しいお店をSwiftDataへ保存し、商品を追加するためのViewへ遷移させる。
                    path.append(shop)
                } catch {
                    print("#アラートを表示させたい")
                    // アラートを表示させる処理を追加したい。
                }
            }
        }
    }
    
    private func deleteShop(at offsets: IndexSet) {
        for index in offsets {
            let shopName = shopList[index].name
            imageFileManager.deleteShopImage(shopName: shopName)
            let selectedShop = savedShopList[index]
            context.delete(selectedShop)
            shopList.remove(atOffsets: offsets)
        }
    }
    
}

// 追加されたお店の雛形
private struct ShopRowView: View {
    
    let imageFileManager = ImageFileManager()
    let shop: Shop
    
    var body: some View {
        
        HStack{
            //画像
            let shopName = shop.name
            let uiImage = imageFileManager.loadShopImage(shopName: shopName)
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
            //お店の名前
            VStack {
                Spacer()//🍔中央寄せ
                HStack {
                    Text(shopName)
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
