//
//  SimpleData.swift
//  SwiftDataDemo
//
//  Created by sako0602 on 2024/10/25.
//

import SwiftUI
import SwiftData

struct SimpleData: View {
    
    @Environment(\.modelContext) var context
    @Query private var items:[Item] = []
    @State private var newItem = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("入力してください", text: $newItem)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                Spacer()
                if !items.isEmpty {
                    List {
                        ForEach(items) { item in
                            Text(item.name)
                        }
                        .onDelete(perform: deleteItem(at:))
                    }
                } else {
                    Text("Empty")
                }
                Spacer()
            }
            .navigationTitle("SwiftDataDemo")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("追加"){
                        let newItem = Item(name: newItem)
                        context.insert(newItem)
                        try? context.save()
                        self.newItem = ""
                    }
                }
            }
            //追加ボタンがタップされたタイミングでTextFieldの中身を空にする
            .onChange(of: newItem) { oldValue, _ in
                newItem = oldValue
            }
        }
    }
    
    private func deleteItem(at offsets: IndexSet) {
        for index in offsets {
            let selectedItem = items[index]
            context.delete(selectedItem)
        }
    }
}


#Preview {
    SimpleData()
        .modelContainer(for: [Item.self])
}


//①modelの作成

@Model
class Item: Identifiable {
    var id = UUID()
    var name: String
    init(name: String){
        self.name = name
    }
}
