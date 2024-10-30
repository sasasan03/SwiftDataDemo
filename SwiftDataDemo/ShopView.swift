//
//  ShopView.swift
//  SwiftDataDemo
//
//  Created by sako0602 on 2024/10/25.



//                    Button("追加") {
//                        // TODO: 配列にGoodをする処理を書く
//                        let newShop = saveShop(image: selectedImage)
//                        context.insert(newShop)
//                        try? context.save()
//                        self.shopName = ""
//                    }
//}追加ボタン


//    private func saveShop(image: UIImage?) -> Shop {
//        guard let image, let imageData = image.jpegData(compressionQuality: 0.8) else { return Shop(name: "失敗", imageData: nil, goods: []) }
//        return Shop(
//            name: shopName,
//            imageData: imageData,
//            goods: []
//        )
//    }


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

    
    var body: some View {
        NavigationStack(path: $path) {
            //OnDeleteを使用するためにListで包む。
            List {
                AddShopRowView()
                    .onTapGesture {
                        showAddShopView = true
                    }
                ForEach(shopList){ shop in
                    NavigationLink(value: shop) {
                        ShopRowView(shop: shop)
                    }
                }
                .onDelete(perform: deleteItem)
            }
            .listStyle(.grouped)
            .navigationTitle("お店一覧")
            .navigationDestination(for:  Shop.self, destination: { shop in
                // .constantで包むことでBindingを要求してくるViewに対応できる。
                GoodsView(shop: .constant(shop))
            })
            
        }
        .onAppear {
            //アプリ立ち上げ時に保存したデータを、編集するためのプロパティへ代入
            shopList = savedShopList
        }
        .sheet(isPresented: $showAddShopView) {
            AddShopSheetView() { shopName, shopImage in
                let shop = Shop(name: shopName, imageData: shopImage, goods: [])
                context.insert(shop)
                shopList.append(shop)
                do {
                    try context.save()
                    showAddShopView = false
                } catch {
                    print("addShopSheet closure error.")
                }
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

struct ShopRowView: View {
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

struct AddShopRowView: View {
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
