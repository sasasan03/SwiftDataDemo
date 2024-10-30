//
//  ShopRowView.swift
//  SwiftDataDemo
//
//  Created by sako0602 on 2024/10/27.
//

import SwiftUI
import SwiftData

struct GoodsView: View {
    
    @Environment(\.modelContext) var context
    @Binding var shop: Shop
    @State private var showEditModal = false
    @State private var showAddModal = false
    @State private var goodText = ""
    @State private var selectedGood: Good?
    @State private var selectedImage: UIImage? = UIImage(systemName: "photo")
    @State private var isPickerPresented = false
    @State private var showAddGoodsModal = false
    
    var body: some View {
        VStack {
            Text("『\(shop.name)』に商品を追加する")
            if shop.goods.isEmpty {
                Text("グッズを追加してください。")
            } else {
                List {
                    ForEach(shop.goods) { good in
                        HStack {
                            Text("\(good)")
                        }
                    }
                }
                .sheet(item: $selectedGood) { good in
                    SheetView(good: good)
                }
            }
            Spacer()
        }
        .navigationTitle("グッズ編集画面")
        //Goodを追加された後に、一気に保存する。右上プラスボタン
        .toolbar{
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showAddGoodsModal = true
                } label: {
                    Text("追加")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    let newShop = saveShop(image: selectedImage)
                    context.insert(newShop)
                    try? context.save()
                } label: {
                    Text("保存")
                }
            }
        }
        .sheet(isPresented: $showAddGoodsModal) {
            SheetView(good: Good(name: "魚", price: 150))
        }
        .sheet(isPresented: $isPickerPresented) {
            PhotoPicker(selectedImage: $selectedImage)
        }
    }
    
    //追加と同時にデータの保存を行う
    private func saveShop(image: UIImage?) -> Shop {
        guard let image,
              let imageData = image.jpegData(compressionQuality: 0.8) else {
            return Shop(name: "失敗", imageData: nil, goods: [])
        }
        return Shop(
            name: shop.name,
            imageData: imageData,
            goods: []
        )
    }

    
}

struct SheetView: View {
    
    let good: Good
    @State private var goodName = ""
//    @Binding var good
    
    var body: some View {
        HStack{
            TextField("商品を入力してください", text: $goodName)
            Button("保存"){
                
            }
        }
    }
}


#Preview {
    GoodsView(shop: .constant(Shop(name: "ナイキ", imageData: nil, goods: [])))
}
