//
//  LaunchScreenView.swift
//  AryHoops
//
//  Created by aryan on 11/30/24.
//

import SwiftUI

struct LaunchScreenView: View {
    @State private var isAnimating = false
    @State private var showText = false
    
    var body: some View {
        ZStack {
            Color(red: 0.11, green: 0.11, blue: 0.12)  // Almost black
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image("mango")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding(.top, -50)
                    .scaleEffect(isAnimating ? 1.0 : 0.5)
                    .opacity(isAnimating ? 1 : 0)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                
                Text("AryHoops")
                    .font(.custom("Noteworthy-Bold", size: 55))
                    .foregroundColor(.white)
                    .padding(.top, -30)
                    .opacity(showText ? 1 : 0)
                    .offset(y: showText ? 0 : 20)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                isAnimating = true
            }
            
            withAnimation(.easeInOut(duration: 0.8).delay(0.4)) {
                showText = true
            }
        }
    }
}

#Preview {
    LaunchScreenView()
}
