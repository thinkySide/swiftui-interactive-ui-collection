//
//  ContentView.swift
//  Apple-Style-Onboarding
//
//  Created by 김민준 on 7/27/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showOnboarding: Bool = true
    
    var body: some View {
        NavigationStack {
            List {
                
            }
            .navigationTitle("Apple Games")
        }
        .sheet(isPresented: $showOnboarding) {
            AppleOnboardingView(
                tint: .red,
                title: "Welcome to Apple Games") {
                    Image(systemName: "gamecontroller.fill")
                        .font(.system(size: 50))
                        .frame(width: 100, height: 100)
                        .foregroundStyle(.white)
                        .background(.red.gradient, in: .rect(cornerRadius: 25))
                        .frame(height: 180)
                } cards: {
                    AppleOnboardingCard(
                        symbol: "list.bullet",
                        title: "See What's New, Just for You",
                        subtitle: "Explore what's happenging in your games and what to play next."
                    )
                    
                    AppleOnboardingCard(
                        symbol: "person.2",
                        title: "Play and Compete with Friends",
                        subtitle: "Challenge friends, see what they're playing, and play together."
                    )
                    
                    AppleOnboardingCard(
                        symbol: "square.stack",
                        title: "All Your Games in One Place",
                        subtitle: "Access your full game library, including Apple Arcade and Game Center titles."
                    )
                } footer: {
                    VStack(alignment: .leading, spacing: 4) {
                        Image(systemName: "person.3.fill")
                            .foregroundStyle(.red)
                        
                        Text("Your gameplay information, including what you play and your game activity, is used to improve Game Center.")
                            .font(.caption2)
                            .foregroundStyle(.gray)
                    }
                } onContinue: {
                    showOnboarding = false
                }
        }
    }
}

#Preview {
    ContentView()
}
