//
//  ContentView.swift
//  AryHoops
//
//  Created by aryan on 12/3/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn = false
    @State private var selectedTab = "Home" // Default selected tab

    var body: some View {
        NavigationStack {
            if isLoggedIn {
                ZStack {
                    LinearGradient(
                        colors: [Color(red: 89/255, green: 96/255, blue: 113/255)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                    
                    VStack(spacing: 0) {
                        switch selectedTab {
                        case "Home":
                            HomeView()
                        case "Betting":
                            BettingView()
                        case "Favorites":
                            FavoriteView()
                        default:
                            HomeView()
                        }
                        
                        // Bottom Navigation Bar
                        HStack {
                            BottomNavButton(title: "Home", imageName: "house", isSelected: selectedTab == "Home")
                                .onTapGesture {
                                    withAnimation {
                                        selectedTab = "Home"
                                    }
                                }
                            BottomNavButton(title: "Betting", imageName: "dollar-sign", isSelected: selectedTab == "Betting")
                                .onTapGesture {
                                    withAnimation {
                                        selectedTab = "Betting"
                                    }
                                }
                            BottomNavButton(title: "Favorites", imageName: "bookmark", isSelected: selectedTab == "Favorites")
                                .onTapGesture {
                                    withAnimation {
                                        selectedTab = "Favorites"
                                    }
                                }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 3)
                        .background(Color(.black).opacity(0.3))
                        .edgesIgnoringSafeArea(.bottom)
                    }
                }
            } else {
                VStack {
                    LoginView(isLoggedIn: $isLoggedIn)
                    // RegistrationView is used, pass the isLoggedIn binding
                }
            }
        }
    }
}

struct BottomNavButton: View {
    let title: String
    let imageName: String
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
            Text(title)
                .font(.caption.bold())
        }
        .foregroundColor(isSelected ? .white : .gray)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(isSelected ? Color(red: 1.0, green: 0.6, blue: 0.2) : Color.clear)
        .cornerRadius(20)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
