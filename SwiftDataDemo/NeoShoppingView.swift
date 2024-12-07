//
//  NeoShoppingView.swift
//  SwiftDataDemo
//
//  Created by sako0602 on 2024/12/06.
//

import SwiftUI

struct GoalItem: Identifiable {
    let id = UUID()
    let systemName: String
    var location: CGPoint = .zero
    let startPositionWidth: Double
    let startPositionHeight: Double
    var isGoal = false
    
    func makeBackGroundItem() -> [GoalItem] {
        return (0 ..< 10).map { _ in
            GoalItem(systemName: systemName,
                     startPositionWidth: startPositionWidth,
                     startPositionHeight: startPositionHeight)
        }
    }
}

struct NeoShoppingView: View {
    
    @State var gohyakuYen: [GoalItem] = []
    @State var hyakuYen: [GoalItem] = []
    @State var juYen: [GoalItem] = []
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ZStack{
                    Image("shop")
                        .resizable()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    VStack{
                        Image("tore")
                            .resizable()
                            .frame(width: geometry.size.width * 0.7,
                                   height: geometry.size.height * 0.2
                            )
                            .offset(y: 50)
                        Spacer()
                    }
                }
                ZStack {
                    ForEach($gohyakuYen){ $item in
                        Image(item.systemName)
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
                    ForEach($hyakuYen) { $item in
                        Image(item.systemName)
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
                    ForEach($juYen) { $item in
                        Image(item.systemName)
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
                }
                VStack{
                    Spacer()
                    Button {
                        
                    } label: {
                        ZStack{
                            Rectangle()
                                .fill(Color.white)
                                .frame(height: geometry.size.height * 0.1)
                            Text("支払う")
                                .font(.system(size: 30))
                        }
                    }
                }
            }
        }
        .ignoresSafeArea(edges: .all)
        .onAppear{
            gohyakuYen = GoalItem(systemName: "gohyaku",
                                  startPositionWidth: 0.6,
                                  startPositionHeight: 0.83).makeBackGroundItem()
            hyakuYen = GoalItem(systemName: "hyaku",
                                startPositionWidth: 0.25,
                                startPositionHeight: 0.7).makeBackGroundItem()
            juYen = GoalItem(systemName: "ju",
                             startPositionWidth: 0.75,
                             startPositionHeight: 0.7).makeBackGroundItem()
        }
    }
}

#Preview {
    NeoShoppingView()
}
