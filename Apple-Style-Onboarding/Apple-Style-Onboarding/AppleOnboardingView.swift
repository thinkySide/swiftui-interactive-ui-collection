//
//  AppleOnboardingView.swift
//  Apple-Style-Onboarding
//
//  Created by 김민준 on 7/27/25.
//

import SwiftUI

struct AppleOnboardingCard: Identifiable {
    var id: String = UUID().uuidString
    var symbol: String
    var title: String
    var subtitle: String
}

@resultBuilder
struct OnboardingCardResultBuilder {
    static func buildBlock(_ components: AppleOnboardingCard...) -> [AppleOnboardingCard] {
        components.compactMap { $0 }
    }
}

struct AppleOnboardingView<Icon: View, Footer: View>: View {
    
    var tint: Color
    var title: String
    var icon: Icon
    var cards: [AppleOnboardingCard]
    var footer: Footer
    var onContinue: () -> Void
    
    @State private var animateIcon: Bool = false
    @State private var animateTitle: Bool = false
    @State private var animateCards: [Bool]
    @State private var animateFooter: Bool = false
    
    init(
        tint: Color,
        title: String,
        @ViewBuilder icon: @escaping () -> Icon,
        @OnboardingCardResultBuilder cards: @escaping () -> [AppleOnboardingCard],
        @ViewBuilder footer: @escaping () -> Footer,
        onContinue: @escaping () -> Void
    ) {
        self.tint = tint
        self.title = title
        self.icon = icon()
        self.cards = cards()
        self.footer = footer()
        self.onContinue = onContinue
        
        self._animateCards = .init(
            initialValue: Array(repeating: false, count: self.cards.count)
        )
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 20) {
                    icon
                        .frame(maxWidth: .infinity)
                        .blurSlide(animateIcon)
                    
                    Text(title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .blurSlide(animateTitle)
                    
                    CardsView()
                }
            }
            .scrollIndicators(.hidden)
            .scrollBounceBehavior(.basedOnSize)
            
            VStack(spacing: 12) {
                footer
                
                Button(action: onContinue) {
                    Text("Continue")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                    #if os(macOS)
                        .padding(.vertical, 8)
                    #else
                        .padding(.vertical, 4)
                    #endif
                }
                .tint(tint)
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .padding(.bottom, 10)
            }
            .blurSlide(animateFooter)
        }
        .frame(maxWidth: 330)
        .interactiveDismissDisabled()
        .allowsHitTesting(animateFooter)
        .task {
            guard !animateIcon else { return }
            await delayAnimation(0.35) {
                animateIcon = true
            }
            await delayAnimation(0.2) {
                animateTitle = true
            }
            try? await Task.sleep(for: .seconds(0.2))
            for index in animateCards.indices {
                let delay = Double(index) * 0.1
                await delayAnimation(delay) {
                    animateCards[index] = true
                }
            }
            
            await delayAnimation(0.2) {
                animateFooter = true
            }
        }
        .setupOnboarding()
    }
    
    @ViewBuilder
    func CardsView() -> some View {
        Group {
            ForEach(cards.indices, id: \.self) { index in
                let card = cards[index]
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: card.symbol)
                        .font(.title2)
                        .foregroundStyle(tint)
                        .symbolVariant(.fill)
                        .frame(width: 45)
                        .offset(y: 10)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(card.title)
                            .font(.title3)
                            .lineLimit(1)
                        
                        Text(card.subtitle)
                            .lineLimit(2)
                    }
                }
                .blurSlide(animateCards[index])
            }
        }
    }
    
    func delayAnimation(_ delay: Double, action: @escaping () -> Void) async {
        try? await Task.sleep(for: .seconds(delay))
        withAnimation(.smooth) {
            action()
        }
    }
}

extension View {
    
    @ViewBuilder
    func blurSlide(_ show: Bool) -> some View {
        self
            .compositingGroup()
            .blur(radius: show ? 0 : 10)
            .opacity(show ? 1 : 0)
            .offset(y: show ? 0 : 100)
        
    }
    
    @ViewBuilder
    fileprivate func setupOnboarding() -> some View {
        #if os(macOS)
        self
            .padding(.horizontal, 20)
            .frame(minHeight: 600)
        #else
        if UIDevice.current.userInterfaceIdiom == .pad {
            if #available(iOS 18, *) {
                self
                    .presentationSizing(.fitted)
                    .padding(.horizontal, 24)
            } else {
                self
            }
        } else {
            self
        }
        #endif
    }
}

#Preview {
    ContentView()
}
