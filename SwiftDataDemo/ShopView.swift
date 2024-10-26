//
//  ShopView.swift
//  SwiftDataDemo
//
//  Created by sako0602 on 2024/10/25.
//

import SwiftUI
import SwiftData

struct ShopView: View {
    
    @Environment(\.modelContext) var context
    @Query private var shopList:[Shop] = []
    @State private var path: [Shop] = []
    @State private var newShop = ""
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                TextField("お店を入力してください", text: $newShop)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                Spacer()
                List(shopList){ shop in
                    // 次のViewに対して渡すvalue
                    NavigationLink(value: shop) {
                        Text(shop.name)
                    }
                }
            }
            .navigationTitle("AEON(イオン)")
            .navigationDestination(for:  Shop.self, destination: { shop in
                RowView(shop: .constant(shop))
            })
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("追加"){
                        let newShop = Shop(name: newShop, goods: [])
                        context.insert(newShop)
                        try? context.save()
                        self.newShop = ""
                    }
                }
            }
            //追加ボタンがタップされたタイミングでTextFieldの中身を空にする
            .onChange(of: newShop) { oldValue, _ in
                newShop = oldValue
            }
        }
    }
}

struct RowView: View {
    
    @Binding var shop: Shop
    
    var body: some View {
        Group {
            if shop.goods.isEmpty {
                Text("グッズを追加してください。")
            } else {
                List(shop.goods) { good in
                    Text("グッズは『\(good.name)』です")
                }
            }
        }
        .navigationTitle(shop.name)
    }
}

//お店
@Model
class Shop: Identifiable {
    var id = UUID()
    var name: String
    var goods: [Good]
    
    init(name: String, goods: [Good]) {
        self.name = name
        self.goods = goods
    }
}

//お店にある商品
@Model
class Good: Identifiable {
    var id = UUID()
    var name: String
    var price: Int
    init(name: String, price: Int) {
        self.name = name
        self.price = price
    }
}



#Preview {
    ShopView()
        .modelContainer(for: [Shop.self])
}
