//
//  ContentView.swift
//  Resizable-Header-ScrollView
//
//  Created by 김민준 on 7/26/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Example 1") {
                    Example1View()
                }
                
                NavigationLink("Example 2") {
                    Example2View()
                        .navigationBarBackButtonHidden()
                }
            }
            .navigationTitle("Resizable Header")
        }
    }
}

struct Example1View: View {
    
    @State private var isSticky: Bool = false
    
    var body: some View {
        ResizableHeaderScrollView(
            mininmumHeight: 100,
            maximumHeight: 250,
            ignoreSafeAreaTop: false,
            isSticky: isSticky,
            header: { progress, safeArea in
                RoundedRectangle(cornerRadius: 30)
                    .fill(.indigo.gradient)
                    .overlay(
                        Text("\(progress)")
                            .foregroundStyle(.white)
                    )
                    .padding(.horizontal, 16)
                    .padding(.top, 10)
            },
            content: {
                VStack(spacing: 12) {
                    Toggle("Sticky Header", isOn: $isSticky)
                        .padding(16)
                        .background(.gray.opacity(0.2), in: .rect(cornerRadius: 16))
                    
                    DummyContent()
                }
                .padding(16)
            }
        )
    }
    
    @ViewBuilder
    func DummyContent() -> some View {
        LazyVGrid(columns: Array(repeating: .init(), count: 2)) {
            ForEach(1...50, id: \.self) { index in
                RoundedRectangle(cornerRadius: 25)
                    .fill(.gray.opacity(0.2))
                    .frame(height: 160)
            }
        }
    }
}

struct Example2View: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ResizableHeaderScrollView(
            mininmumHeight: 70,
            maximumHeight: 200,
            ignoreSafeAreaTop: true,
            isSticky: false,
            header: { progress, safeArea in
                HeaderView(progress)
            },
            content: {
                VStack(spacing: 16) {
                    XboxAppGamePageUI()
                    DummyContent()
                }
                .padding(16)
            }
        )
        .preferredColorScheme(.dark)
    }
    
    @ViewBuilder
    func HeaderView(_ progress: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                    .frame(width: 36, height: 36)
                    .background(.bar, in: .rect(cornerRadius: 10))
            }
            .offset(y: 58 * progress)
            
            HStack(spacing: 12) {
                let size: CGFloat = 120 - (progress * 80)
                
                Image(.header)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size, height: size)
                    .clipShape(.rect(cornerRadius: 10))
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("MINTOL GAMING")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text("HANTOL CO. LTD")
                        .font(.callout)
                        .foregroundStyle(.gray)
                }
                /// 해당 View와 자식 View들을 하나의 렌더링 그룹으로 묶어서 효과를 적용합니다.
                .compositingGroup()
                /// progress 값에 따라 왼쪽을 기준으로 축소합니다.
                .scaleEffect(1 - (0.2 * progress), anchor: .leading)
            }
            .offset(x: 45 * progress)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
        .background {
            let opacity = (progress - 0.7) / 0.3
            
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(opacity)
        }
    }
    
    @ViewBuilder
    func XboxAppGamePageUI() -> some View {
        VStack(spacing: 10) {
            Button {
                
            } label: {
                VStack(spacing: 6) {
                    Text("Install to +")
                        .foregroundStyle(.white)
                    
                    Text("Xbox Series X|S")
                        .font(.caption)
                        .foregroundStyle(.white.secondary)
                }
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(Color(UIColor.systemGreen), in: .rect(cornerRadius: 10))
            }
            
            HStack(spacing: 10) {
                Button {
                    
                } label: {
                    VStack(spacing: 6) {
                        Text("Buy")
                            .foregroundStyle(.white)
                        
                        Text("Sone Amount...")
                            .font(.caption)
                            .foregroundStyle(.orange)
                    }
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(.gray.opacity(0.2), in: .rect(cornerRadius: 10))
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                        .frame(width: 80, height: 60)
                        .background(.gray.opacity(0.2), in: .rect(cornerRadius: 10))
                }
            }
        }
    }
    
    @ViewBuilder
    func DummyContent() -> some View {
        LazyVGrid(columns: Array(repeating: .init(), count: 2)) {
            ForEach(1...50, id: \.self) { index in
                RoundedRectangle(cornerRadius: 25)
                    .fill(.gray.opacity(0.2))
                    .frame(height: 160)
            }
        }
    }
}

#Preview {
    ContentView()
}
