//
//  ScheduleView.swift
//  AryHoops
//
//  Created by aryan on 12/6/24.
//

import SwiftUI

struct ScheduleView: View {
    @State private var games: [ScheduleGame] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Upcoming Schedule")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .tracking(0.5)
                .padding(.horizontal)
                .padding(.bottom, 8)

            if isLoading {
                ProgressView("Loading schedule...")
                    .foregroundColor(.white)
                    .padding()
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red.opacity(0.9))
                    .font(.system(size: 15, weight: .medium))
                    .padding()
            } else if games.isEmpty {
                Text("No games available")
                    .foregroundColor(.gray)
                    .font(.system(size: 15, weight: .medium))
                    .padding()
            } else {
                VStack(spacing: 2) {
                    ForEach(games.prefix(5), id: \.id) { game in
                        ScheduleRow(
                            team1: game.home.name,
                            team2: game.away.name,
                            time: formatTime(from: game.scheduled),
                            date: formatDate(from: game.scheduled)
                        )
                    }
                }
                .background(Color.white.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal)
            }
        }
        .onAppear {
            fetchSchedule()
        }
    }

    private func fetchSchedule() {
        GameScheduleAPI.shared.fetchUpcomingGames(completion:) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let allGames):
                    let now = Date()
                    self.games = allGames.filter { game in
                        guard let gameDate = ISO8601DateFormatter().date(from: game.scheduled) else { return false }
                        return gameDate > now && game.status.lowercased() == "scheduled"
                    }
                    .sorted(by: { $0.scheduled < $1.scheduled })
                    self.isLoading = false
                case .failure(let error):
                    self.errorMessage = "Failed to load schedule: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }

    private func formatDate(from isoDate: String) -> String {
        guard let date = ISO8601DateFormatter().date(from: isoDate) else { return "Invalid date" }
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d" // Example: Tue, Dec 12
        return formatter.string(from: date)
    }

    private func formatTime(from isoDate: String) -> String {
        guard let date = ISO8601DateFormatter().date(from: isoDate) else { return "Invalid time" }
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct ScheduleRow: View {
    let team1: String
    let team2: String
    let time: String
    let date: String

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    Image(getLogoName(for: team1))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 34, height: 34)
                    Text(team1)
                        .foregroundColor(.white)
                        .font(.system(size: 14.5, weight: .semibold))
                        .tracking(0.3)
                }
                HStack(spacing: 12) {
                    Image(getLogoName(for: team2))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 34, height: 34)
                    Text(team2)
                        .foregroundColor(.white)
                        .font(.system(size: 14.5, weight: .semibold))
                        .tracking(0.3)
                }
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 6) {
                Text(date)
                    .foregroundColor(.white.opacity(0.7))
                    .font(.system(size: 14, weight: .medium))
                    .tracking(0.2)
                Text(time)
                    .foregroundColor(.white.opacity(0.8))
                    .font(.system(size: 15.5, weight: .semibold))
                    .tracking(0.2)
                    .monospacedDigit()
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(Color.white.opacity(0.05))
    }
    
    private func getLogoName(for teamName: String) -> String {
        let lowercasedName = teamName.split(separator: " ").last?.lowercased() ?? teamName.lowercased()
        print("Team name: \(teamName), Parsed name: \(lowercasedName)")
        
        // Special cases
        if lowercasedName == "76ers" {
            return "philadelphia-76ers-logo"
        }
        
        if lowercasedName.contains("trail") || lowercasedName.contains("blaz") {
            return "portland-trailblazers-logo"
        }
        
        // Map team nicknames to city names
        let teamLogoMapping: [String: String] = [
            "celtics": "boston",
            "nets": "brooklyn",
            "knicks": "new-york",
            "raptors": "toronto",
            "bulls": "chicago",
            "cavaliers": "cleveland",
            "pistons": "detroit",
            "pacers": "indiana",
            "bucks": "milwaukee",
            "hawks": "atlanta",
            "hornets": "charlotte",
            "heat": "miami",
            "magic": "orlando",
            "wizards": "washington",
            "nuggets": "denver",
            "timberwolves": "minnesota",
            "thunder": "oklahoma-city",
            "jazz": "utah",
            "warriors": "golden-state",
            "clippers": "los-angeles",
            "lakers": "los-angeles",
            "suns": "phoenix",
            "kings": "sacramento",
            "mavericks": "dallas",
            "rockets": "houston",
            "grizzlies": "memphis",
            "pelicans": "new-orleans",
            "spurs": "san-antonio"
        ]
        
        let logoName = if let cityName = teamLogoMapping[lowercasedName] {
            if cityName == "los-angeles" {
                "los-angeles-\(lowercasedName)-logo"
            } else {
                "\(cityName)-\(lowercasedName)-logo"
            }
        } else {
            "\(lowercasedName)-logo"
        }
        
        print("Logo name: \(logoName)")
        return logoName
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .preferredColorScheme(.dark)
    }
}
