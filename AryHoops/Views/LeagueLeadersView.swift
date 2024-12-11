//
//  LeagueLeadersView.swift
//  AryHoops
//
//  Created by aryan on 12/4/24.
//

import SwiftUI

struct LeagueLeadersView: View {
    
    @State private var leaders: [LeagueCategory: [LeaderRank]] = [:]
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("League Leaders")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .tracking(0.5)
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                
                if isLoading {
                    ProgressView("Loading leaders...")
                        .foregroundColor(.white)
                        .padding()
                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    ForEach(LeagueCategory.allCases, id: \.self) { category in
                        if let ranks = leaders[category] {
                            VStack(alignment: .leading, spacing: 10) {
                                Text(category.rawValue)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                    .tracking(0.3)
                                    .padding(.horizontal)
                                
                                LeagueStatsView(category: category, ranks: ranks)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .onAppear {
            fetchLeaders()
        }
    }
    
    private func fetchLeaders() {
        LeaderboardAPI.shared.fetchLeaders { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let categories):
                    var categoryLeaders: [LeagueCategory: [LeaderRank]] = [:]
                    
                    for category in LeagueCategory.allCases {
                        if let categoryData = categories.first(where: { $0.name == category.apiName && $0.type == "average" }) {
                            categoryLeaders[category] = Array(categoryData.ranks.prefix(3)) // Top 3 players
                        }
                    }
                    
                    self.leaders = categoryLeaders
                    self.isLoading = false
                case .failure(let error):
                    self.errorMessage = "Failed to load leaders: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
}

// Updated Enum for League Categories
enum LeagueCategory: String, CaseIterable {
    case points = "Points Per Game"
    case assists = "Assists Per Game"
    case rebounds = "Rebounds Per Game"
    case steals = "Steals Per Game"
    case threePoints = "3-Point Made Per Game"
    case freethrowsattempts = "Free Throws Attempted Per Game"

    var apiName: String {
        switch self {
        case .points: return "points"
        case .assists: return "assists"
        case .rebounds: return "rebounds"
        case .steals: return "steals"
        case .threePoints: return "three_points_made"
        case .freethrowsattempts: return "free_throws_att"
        }
    }

    var abbreviation: String {
        switch self {
        case .points: return "PTS"
        case .assists: return "AST"
        case .rebounds: return "REB"
        case .steals: return "STL"
        case .threePoints: return "3PT"
        case .freethrowsattempts: return "FT"
        }
    }
}

struct LeagueStatsView: View {
    let category: LeagueCategory
    let ranks: [LeaderRank]

    var body: some View {
        VStack(spacing: 0) {
            LeagueHeaderRow(category: category)
            ForEach(ranks, id: \.player.id) { rank in
                LeaderRow(player: rank.player.full_name, stat: String(format: "%.1f", rank.score))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.1))
        .cornerRadius(15)
        .padding(.horizontal)
    }
}

// Supporting views
struct LeagueHeaderRow: View {
    let category: LeagueCategory
    var body: some View {
        HStack {
            Text("Player")
                .font(.system(size: 14, weight: .medium))
                .tracking(0.3)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(category.abbreviation)
                .font(.system(size: 14, weight: .medium))
                .tracking(0.3)
                .frame(width: 70, alignment: .center)
        }
        .foregroundColor(.white.opacity(0.6))
        .fontWeight(.bold)
        .padding(.vertical, 10)
        .padding(.horizontal)
        .background(Color.black.opacity(0.08))
    }
}

struct LeaderRow: View {
    let player: String
    let stat: String
    
    var body: some View {
        HStack {
            Text(player)
                .font(.system(size: 14, weight: .regular))
                .tracking(0.3)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(stat)
                .font(.system(size: 14, weight: .semibold))
                .tracking(0.3)
                .frame(width: 70, alignment: .center)
                .monospacedDigit()
        }
        .foregroundColor(.white)
        .font(.callout)
        .padding(.vertical, 10)
        .padding(.horizontal)
        .background(Color.white.opacity(0.05))
    }
}

struct LeagueLeadersView_Previews: PreviewProvider {
    static var previews: some View {
        LeagueLeadersView()
            .preferredColorScheme(.dark)
    }
}
