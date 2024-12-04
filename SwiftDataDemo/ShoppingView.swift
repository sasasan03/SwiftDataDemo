//
//  ShoppingView.swift
//  SwiftDataDemo
//
//  Created by sako0602 on 2024/11/16.
//

import SwiftUI

struct GoalItem: Identifiable {
    let id = UUID()
    let systemName: String
    var location: CGPoint = .zero
    let startPositionWidth: Double
    let startPositionHeight: Double
    var isGoal = false
}

class GoalViewModel: ObservableObject {
    @Published var goalItems: [GoalItem] = [
        GoalItem(systemName: "soccerball", startPositionWidth: 0.25, startPositionHeight: 0.9),
        GoalItem(systemName: "baseball", startPositionWidth: 0.75, startPositionHeight: 0.9)
    ]
}

struct ShoppingView: View {
    
    @State private var isGoal = false
    @StateObject var vm = GoalViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Divider()
                    .frame(height: 5)
                    .background(Color.red)
                    .position(x: 201, y: geometry.size.height * 0.2)
                ForEach($vm.goalItems){ $item in
                        Image(systemName: item.systemName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundStyle(item.isGoal ? .red : .black )
                            .position(x: item.location == .zero
                                      ? geometry.size.width * item.startPositionWidth
                                      : item.location.x,
                                      y: item.location == .zero
                                      ? geometry.size.height * item.startPositionHeight
                                      : item.location.y)
                            .gesture(
                                DragGesture()
                                .onChanged { value in
                                    item.location = value.location
                                    print("#start", value.startLocation)
                                }
                                .onEnded { value in
                                    if value.location.y < 200 {
                                        item.isGoal = true
                                    } else {
                                        item.isGoal = false
                                    }
                                }
                            )
                }
//                Text("x:\(item.location.x),y:\(item.location.y)")
            }
        }
        .background(Color.green)
    }
}




#Preview {
    ShoppingView()
}
