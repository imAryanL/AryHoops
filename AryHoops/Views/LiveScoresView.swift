//
//  LiveScoresView.swift
//  AryHoops
//
//  Created by aryan on 12/6/24.
//

import SwiftUI

struct LiveScoresView: View {
    // State variables to hold live scores and loading status
    @State private var liveGames: [LiveGameResponse] = []
    @State private var isLoading = true
    @State private var refreshTimer: Timer?
    @State private var isRefreshing = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Live Scores")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .tracking(0.5)
                
                if isRefreshing {
                    ProgressView()
                        .scaleEffect(0.7)
                        .tint(.white)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
            
            if isLoading {
                // Show loading spinner while fetching data
                HStack {
                    ProgressView("Loading Live Games...")
                        .foregroundColor(.white)
                        .padding(.top, 10)
                        .padding(.horizontal)
                    Spacer()
                }
            } else if liveGames.isEmpty {
                // Display message when no live games are available
                VStack(spacing: 15) {
                    Image("bballCourt")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 90, height: 90)
                    
                    VStack(spacing: 5) {
                        Text("No live games currently")
                            .font(.headline)
                            .foregroundColor(.white)
                        HStack(spacing: 4) {
                            Text("Sorry!")
                                .font(.callout)
                                .foregroundColor(.gray)
                            Image("sadEmoji")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 30)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
                .background(Color.white.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal)
            } else {
                // Render list of live games
                ForEach(liveGames.prefix(4), id: \.id) { game in
                    LiveGameBox(game: game)
                }
            }
        }
        .onAppear {
            fetchLiveScores()
            startRefreshTimer()
            // Subscribe to refresh notifications
            NotificationCenter.default.addObserver(
                forName: NSNotification.Name("RefreshData"),
                object: nil,
                queue: .main
            ) { _ in
                fetchLiveScores()
            }
        }
        .onDisappear {
            stopRefreshTimer()
        }
    }
    
    private func startRefreshTimer() {
        print("Starting refresh timer")
        // Set up timer for periodic refresh (every 15 seconds)
        refreshTimer = Timer.scheduledTimer(withTimeInterval: 15.0, repeats: true) { _ in
            print("Timer fired - fetching new data")
            fetchLiveScores()
        }
    }
    
    private func stopRefreshTimer() {
        refreshTimer?.invalidate()
        refreshTimer = nil
    }
    
    private func fetchLiveScores() {
        isRefreshing = true
        print("Fetching live scores...")
        LiveScoreAPI.shared.fetchLiveScores { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let games):
                    print("Received \(games.count) games")
                    self.liveGames = games
                case .failure(let error):
                    print("Error fetching live scores: \(error)")
                }
                self.isLoading = false
                self.isRefreshing = false
            }
        }
    }
}

// MARK: - Supporting View for Team Scores
struct TeamScoreView: View {
    let team: Team
    let points: Int
    let isHomeTeam: Bool
    
    static func getLogoName(for team: Team) -> String {
        let nickname = team.nickname
        
        // Special cases for abbreviated names
        let specialCases: [String: String] = [
            "Blazers": "Trail Blazers",
            "Sixers": "76ers",
            "Timber": "Timberwolves",
            "Timbe": "Timberwolves"
        ]
        
        let actualNickname = specialCases[nickname] ?? nickname
        
        // Map team nicknames to their logo names
        let logoMapping: [String: String] = [
            "Celtics": "boston-celtics",
            "Nets": "brooklyn-nets",
            "Knicks": "new-york-knicks",
            "76ers": "philadelphia-76ers",
            "Raptors": "toronto-raptors",
            "Bulls": "chicago-bulls",
            "Cavaliers": "cleveland-cavaliers",
            "Pistons": "detroit-pistons",
            "Pacers": "indiana-pacers",
            "Bucks": "milwaukee-bucks",
            "Hawks": "atlanta-hawks",
            "Hornets": "charlotte-hornets",
            "Heat": "miami-heat",
            "Magic": "orlando-magic",
            "Wizards": "washington-wizards",
            "Nuggets": "denver-nuggets",
            "Timberwolves": "minnesota-timberwolves",
            "Thunder": "oklahoma-city-thunder",
            "Trail Blazers": "portland-trailblazers",
            "Jazz": "utah-jazz",
            "Warriors": "golden-state-warriors",
            "Clippers": "los-angeles-clippers",
            "Lakers": "los-angeles-lakers",
            "Suns": "phoenix-suns",
            "Kings": "sacramento-kings",
            "Mavericks": "dallas-mavericks",
            "Rockets": "houston-rockets",
            "Grizzlies": "memphis-grizzlies",
            "Pelicans": "new-orleans-pelicans",
            "Spurs": "san-antonio-spurs"
        ]
        
        if let logoName = logoMapping[actualNickname] {
            return "\(logoName)-logo"
        }
        
        // Fallback case
        return "\(nickname.lowercased())-logo"
    }
    
    private var scoreFont: Font {
        if points >= 100 {
            return .system(size: 24, weight: .heavy)
        }
        return .system(size: 28, weight: .heavy)
    }
    
    var body: some View {
        if isHomeTeam {
            HStack(spacing: 30) {
                VStack(alignment: .center, spacing: 4) {
                    Image(TeamScoreView.getLogoName(for: team))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45)
                    Text(team.nickname)
                        .foregroundColor(.white.opacity(0.85))
                        .font(.system(size: 12.5, weight: .semibold))
                        .tracking(0.3)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .frame(width: 65)
                }
                
                Text("\(points)")
                    .foregroundColor(.white)
                    .font(scoreFont)
                    .frame(minWidth: 60, alignment: .trailing)
                    .monospacedDigit()
            }
        } else {
            HStack(spacing: 30) {
                Text("\(points)")
                    .foregroundColor(.white)
                    .font(scoreFont)
                    .frame(minWidth: 60, alignment: .leading)
                    .monospacedDigit()
                
                VStack(alignment: .center, spacing: 4) {
                    Image(TeamScoreView.getLogoName(for: team))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45)
                    Text(team.nickname)
                        .foregroundColor(.white.opacity(0.85))
                        .font(.system(size: 12.5, weight: .semibold))
                        .tracking(0.3)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .frame(width: 65)
                }
            }
        }
    }
}

// MARK: - Live Game Box
struct LiveGameBox: View {
    let game: LiveGameResponse
    
    private var gameTimeDisplay: String {
        if game.periods.current == 4 && (game.status.clock == "0:00" || game.status.clock == nil) {
            return "FINAL"
        } else if game.periods.current == 2 && (game.status.clock == "0:00" || game.status.clock == nil) {
            return "HALF"
        } else {
            return "Q\(game.periods.current) \(game.status.clock ?? "0:00")"
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white.opacity(0.1))
            
            VStack(spacing: 16) {
                HStack(spacing: 6) {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 6, height: 6)
                    Text(gameTimeDisplay)
                        .foregroundColor(.white.opacity(0.85))
                        .font(.system(size: 15, weight: .bold))
                        .tracking(0.5)
                }
                .padding(.top, 12)
                
                HStack {
                    VStack(alignment: .center, spacing: 4) {
                        Image(TeamScoreView.getLogoName(for: game.teams.home))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 45, height: 45)
                        Text(game.teams.home.nickname)
                            .foregroundColor(.white.opacity(0.85))
                            .font(.system(size: 12.5, weight: .semibold))
                            .tracking(0.3)
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)
                    }
                    .frame(minWidth: 65)
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        Text("\(game.scores.home.points)")
                            .foregroundColor(.white)
                            .font(game.scores.home.points >= 100 ? .system(size: 24, weight: .heavy) : .system(size: 28, weight: .heavy))
                            .frame(minWidth: 50, alignment: .trailing)
                            .monospacedDigit()
                        
                        Text("vs")
                            .foregroundColor(.white.opacity(0.5))
                            .font(.system(size: 15, weight: .semibold))
                            .tracking(0.5)
                        
                        Text("\(game.scores.visitors.points)")
                            .foregroundColor(.white)
                            .font(game.scores.visitors.points >= 100 ? .system(size: 24, weight: .heavy) : .system(size: 28, weight: .heavy))
                            .frame(minWidth: 50, alignment: .leading)
                            .monospacedDigit()
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .center, spacing: 4) {
                        Image(TeamScoreView.getLogoName(for: game.teams.visitors))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 45, height: 45)
                        Text(game.teams.visitors.nickname)
                            .foregroundColor(.white.opacity(0.85))
                            .font(.system(size: 12.5, weight: .semibold))
                            .tracking(0.3)
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)
                    }
                    .frame(minWidth: 65)
                }
                .padding(.horizontal, 15)
                .padding(.bottom, 12)
            }
        }
        .frame(height: 130)
        .padding(.horizontal)
    }
}

// MARK: - Preview Provider
struct LiveScoresView_Previews: PreviewProvider {
    static var previews: some View {
        LiveScoresView()
            .preferredColorScheme(.dark)
    }
}
