//
//  DoplicationItemTest.swift
//  SwiftDataDemo
//
//  Created by sako0602 on 2024/12/04.
//

import SwiftUI

struct DoplicationItemTest: View {
    
    @StateObject var vm = GoalViewModel()
    
    var body: some View {
        ZStack{
            ForEach(0 ..< 10, id: \.self) { _ in
                ForEach($vm.goalItems){ $item in
                    Image(systemName: "baseball")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .position(x: item.location.x ,
                                  y: item.location.y)
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
                
            }
        }
    }
}

#Preview {
    DoplicationItemTest()
}
