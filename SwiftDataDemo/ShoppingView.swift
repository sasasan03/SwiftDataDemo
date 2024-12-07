//
//  ShoppingView.swift
//  SwiftDataDemo
//
//  Created by sako0602 on 2024/11/16.
//

import SwiftUI



class GoalViewModel: ObservableObject {
    @Published var goalItems: [GoalItem] = [
        GoalItem(systemName: "soccerball",startPositionWidth: 0.25,startPositionHeight: 0.9),
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
                    ZStack{
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
                        
//                        ForEach(item.makeBackGroundItem()){ backItem in
//                            Image(systemName: backItem.systemName)
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 100, height: 100)
//                                .foregroundStyle(backItem.isGoal ? .red : .black )
//                                .position(x: backItem.location == .zero
//                                          ? geometry.size.width * backItem.startPositionWidth
//                                          : backItem.location.x,
//                                          y: backItem.location == .zero
//                                          ? geometry.size.height * backItem.startPositionHeight
//                                          : backItem.location.y)
//                                .gesture(
//                                    DragGesture()
//                                    .onChanged { value in
//                                        Binding(
//                                            get: { backItem.location },
//                                            set: { newValue in backItem.location = newValue }
//                                        ).wrappedValue = value.location
//                                        print("#start", value.startLocation)
//                                    }
//                                    .onEnded { value in
//                                        if value.location.y < 200 {
//                                            backItem.isGoal = true
//                                        } else {
//                                            backItem.isGoal = false
//                                        }
//                                    }
//                                )
//                        }
                    }
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
