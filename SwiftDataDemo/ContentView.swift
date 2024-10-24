//
//  ContentView.swift
//  SwiftDataDemo
//
//  Created by sako0602 on 2024/10/21.
//

import SwiftUI
//import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) var context
    @State private var items:[Item] = []
    @State private var newItem = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("入力してください", text: $newItem)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                Spacer()
                if !items.isEmpty {
                    List(items){ item in
                        Text(item.name)
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
                        items.append(newItem)
                        context.insert(newItem)
                        try? context.save()
                        self.newItem = ""
                    }
                }
            }
            .onChange(of: newItem) { oldValue, _ in
                newItem = oldValue
            }
        }
    }
}

#Preview {
    ContentView()
}
