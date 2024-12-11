//
//  HomeView.swift
//  AryHoops
//
//  Created by aryan on 12/2/24.
//

import SwiftUI

// MARK: - Main HomeView
struct HomeView: View {
    // MARK: - State Variables
    @State private var selectedTab = "Scores"
    @Namespace private var namespace
    let tabs = ["Scores", "Stats", "Schedule", "Standings"]
    
    var body: some View {
        ZStack {
            // MARK: - Background
            LinearGradient(
                colors: [Color(red: 89/255, green: 96/255, blue: 113/255)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 15) {
                // MARK: - Top Navigation Bar
                HStack {
                    Image("mango")
                        .resizable()
                        .frame(width: 30, height: 30)
                    Text("AryHoops")
                        .font(.custom("Noteworthy-Bold", size: 20))
                        .foregroundColor(.white)
                    Spacer()
                    Image("userIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 35, height: 35)
                        .clipShape(Circle())
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.horizontal)
                
                // MARK: - Tab Selection Bar
                HStack(spacing: 9) {
                    ForEach(tabs, id: \.self) { tab in
                        Button(action: {
                            selectedTab = tab
                            withAnimation {
                                scrollTo(tab)
                            }
                        }) {
                            Text(tab)
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                                .fontWeight(.bold)
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 3)
                                .background(
                                    selectedTab == tab ?
                                    Color(red: 1.0, green: 0.6, blue: 0.2) :
                                        Color(red: 1.0, green: 0.6, blue: 0.2).opacity(0.4)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color(red: 1.0, green: 0.8, blue: 0.4).opacity(0.6), lineWidth: 1.5)
                                )
                                .shadow(
                                    color: Color(red: 1.0, green: 0.8, blue: 0.4).opacity(0.4),
                                    radius: 3,
                                    x: 0,
                                    y: 0
                                )
                                .scaleEffect(selectedTab == tab ? 1.04 : 1.0)
                                .animation(.easeInOut(duration: 0.2), value: selectedTab)
                        }
                    }
                }
                .padding(.horizontal)
                
                // MARK: - Main Content Sections
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 30) {
                            LiveScoresView()
                                .id("Scores")
                            LeagueLeadersView()
                                .id("Stats")
                            ScheduleView()
                                .id("Schedule")
                            StandingsView()
                                .id("Standings")
                        }
                        .padding(.vertical)
                    }
                    .onChange(of: selectedTab) { oldValue, newValue in
                        withAnimation {
                            proxy.scrollTo(newValue, anchor: .top)
                        }
                    }
                }
            }
        }
    }

    
    func scrollTo(_ tab: String) {
        withAnimation(.easeInOut(duration: 0.3)) {
            selectedTab = tab
        }
    }
}



// MARK: - Preview Provider
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
