//
//  ShopRowView.swift
//  SwiftDataDemo
//
//  Created by sako0602 on 2024/10/27.
//

import SwiftUI
import SwiftData

struct GoodsView: View {
    
    @Binding var shop: Shop
    @State private var showAddModal = false
    @State private var selectedGood: Good?
    @State private var goodName = ""
    @State private var isError = false
    
    var body: some View {
        List {
            AddGoodRowView()
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())//ヒットテストをframeの箇所まで伸ばす。
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
        }
        .listStyle(.grouped)
        .sheet(item: $selectedGood) { selectedGood in //タップされたグッズの編集のシート
            AddOrEditGoodsSheetView(good: selectedGood) { saveGood in
                if let index = shop.goods.firstIndex(where: { $0 == selectedGood }) {
                    shop.goods[index] = saveGood
                } else {
                    isError = true
                }
            }
        }
        .sheet(isPresented: $showAddModal){ //新しくグッズをついかするためのシート
            AddOrEditGoodsSheetView(good: nil) { good in
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




private struct AddOrEditGoodsSheetView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var goodName = ""
    @State private var goodPrice = ""
    @State private var selectedImage: UIImage?
    @State private var isPickerPresented = false
    let good: Good?
    let saveGood: (Good) -> Void
    
    init(good: Good?, saveGood:  @escaping (Good) -> Void ){
        if let good {
            //　🟥写真は追加するかどうかは後ほど
            goodName = good.name
            goodPrice = String(good.price)
        }
        self.good = good
        self.saveGood = saveGood
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if let good { //グッズ編集画面(すでに画像、名前、金額を持っている)
                    if let imageData = good.imageData {
                        let uiImage = UIImage(data: imageData)!
                        Image(uiImage:  uiImage)
                    } else {
                        Image(systemName: "photo")
                    }
                    TextField(good.name, text: $goodName)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                    TextField(String(good.price), text: $goodPrice)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                } else { //新しいグッズを追加する
                    Image(systemName: "photo")
                    TextField("グッズを入力してください。", text: $goodName)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                    TextField("金額を入力してください。", text: $goodPrice)
                        .textFieldStyle(.roundedBorder)
                        .padding()
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
                        let goodPrice = Int(goodPrice) ?? 0
                        let good = Good(name: goodName, price: goodPrice, imageData: selectImage)
                        saveGood(good)
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
                    Button {
                        
                    } label: {
                        Text("グッズを追加する...")
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


//#Preview {
//    GoodsView(shop: .constant(Shop(name: "ナイキ", imageData: nil, goods: [])))
//}
