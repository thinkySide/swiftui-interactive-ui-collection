//
//  ContentView.swift
//  iMessage-Morph-Menu-Effect
//
//  Created by 김민준 on 7/29/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var config: MenuConfig = .init(symbolImage: "plus")
    
    var body: some View {
        CustomMenuView(config: $config) {
            /// RootView
            NavigationStack {
                ScrollView(.vertical) {
                    
                }
                .navigationTitle("iMessage")
                .safeAreaInset(edge: .bottom) {
                    BottomBar()
                }
            }
        } actions: {
            /// Sample Action
            MenuAction(symbolImage: "camera", text: "Camera")
            MenuAction(symbolImage: "photo.on.rectangle.angled", text: "Photos")
            MenuAction(symbolImage: "face.smiling", text: "Genmoji")
            MenuAction(symbolImage: "waveform", text: "Audio")
            MenuAction(symbolImage: "apple.logo", text: "App Store")
            MenuAction(symbolImage: "video.badge.waveform", text: "Facetime")
            MenuAction(symbolImage: "rectangle.and.text.magnifyingglass", text: "#Images")
            MenuAction(symbolImage: "suit.heart", text: "Digital Touch")
            MenuAction(symbolImage: "location", text: "Location")
            MenuAction(symbolImage: "music.note", text: "Music")
        }
    }
    
    @ViewBuilder
    func BottomBar() -> some View {
        HStack(spacing: 12) {
            MenuSoureButton(config: $config) {
                Image(systemName: "plus")
                    .font(.title3)
                    .frame(width: 35, height: 35)
                    .background {
                        Circle()
                            .fill(.gray.opacity(0.15))
                            .background(.background, in: .circle)
                    }
            } onTap: {
                print("Tapped")
            }
            
            TextField("Text Message", text: .constant(""))
                .padding(.vertical, 8)
                .padding(.horizontal, 15)
                .background {
                    Capsule()
                        .stroke(.gray.opacity(0.3), lineWidth: 1.5)
                }
        }
        .padding(.horizontal, 15)
        .padding(.bottom, 10)
    }
}

#Preview {
    ContentView()
}
