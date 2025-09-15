//
//  Home.swift
//  Infinite_Looping_ScrollView_iOS_17
//
//  Created by 김민준 on 9/15/25.
//

import SwiftUI

struct Home: View {
    
    @State private var items: [Item] = [
        .red, .green, .blue, .orange, .pink, .purple, .yellow
    ].compactMap { .init(color: $0) }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                GeometryReader {
                    let size = $0.size
                    LoopingScrollView(
                        width: size.width,
                        spacing: 0,
                        items: items) { item in
                            RoundedRectangle(cornerRadius: 15)
                                .fill(item.color.gradient)
                                .padding(.horizontal, 15)
                        }
                        .scrollTargetBehavior(.paging)
                }
                .frame(height: 220)
                // .contentMargins(.horizontal, 15, for: .scrollContent)
            }
            .padding(.vertical, 15)
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    ContentView()
}
