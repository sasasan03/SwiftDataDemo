//
//  SwiftDataDemoApp.swift
//  SwiftDataDemo
//
//  Created by sako0602 on 2024/10/21.
//

import SwiftUI
import SwiftData

@main
struct SwiftDataDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Shop.self])
    }
}
