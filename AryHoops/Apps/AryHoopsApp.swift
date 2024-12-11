//
//  AryHoopsApp.swift
//  AryHoops
//
//  Created by aryan on 11/30/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

// MARK: - Custom Transitions
extension AnyTransition {
    static var slideAndFade: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        )
    }
    
    static var scaleAndFade: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .scale(scale: 0.8).combined(with: .opacity),
            removal: .scale(scale: 1.2).combined(with: .opacity)
        )
    }
}

@main
struct AryHoopsApp: App {
    @State private var showLaunchScreen = true
    @State private var isAnimating = false

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                if showLaunchScreen {
                    LaunchScreenView()
                        .transition(.scaleAndFade)
                        .onAppear {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                isAnimating = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                withAnimation(.easeInOut(duration: 0.7)) {
                                    showLaunchScreen = false
                                }
                            }
                        }
                } else {
                    ContentView()
                        .transition(.slideAndFade)
                        .animation(.easeInOut(duration: 0.5), value: showLaunchScreen)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}
