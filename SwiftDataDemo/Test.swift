//
//  Test.swift
//  SwiftDataDemo
//
//  Created by sako0602 on 2024/12/06.
//

import SwiftUI




struct Test: View {
    var body: some View {
//        VStack{
            ForEach(0 ..< 10) { num in
                VStack{
                    Text("\(num)")
                }
            }
//        }
    }
}

#Preview {
    Test()
}
