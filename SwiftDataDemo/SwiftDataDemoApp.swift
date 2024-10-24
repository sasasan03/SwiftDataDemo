//
//  SwiftDataDemoApp.swift
//  SwiftDataDemo
//
//  Created by sako0602 on 2024/10/21.
//

import SwiftUI
import SwiftData

// ②modelContinerを作成

@main
struct SwiftDataDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Item.self])
    }
}
