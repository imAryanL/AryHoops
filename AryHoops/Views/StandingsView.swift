//
//  StandingsView.swift
//  AryHoops
//
//  Created by aryan on 12/2/24.
//

import SwiftUI

struct StandingsView: View {
    @State private var easternTeams: [StandingsTeam] = []
    @State private var westernTeams: [StandingsTeam] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Current Game Standings")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .tracking(0.5)
                    .padding(.horizontal)
                    .padding(.bottom, 8)

                if isLoading {
                    ProgressView("Loading Standings...")
                        .foregroundColor(.white)
                        .padding(.top)
                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    // Eastern Conference
                    ConferenceSection(title: "Eastern Conference", teams: easternTeams)

                    // Western Conference
                    ConferenceSection(title: "Western Conference", teams: westernTeams)
                }
            }
            .padding(.vertical)
        }
        .onAppear {
            fetchStandingsData()
        }
    }

    // MARK: - Fetch Standings
    private func fetchStandingsData() {
        StandingsAPI.shared.fetchStandings { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let (eastern, western)):
                    self.easternTeams = eastern.sorted { team1, team2 in
                        let pct1 = Double(team1.wins) / Double(team1.wins + team1.losses)
                        let pct2 = Double(team2.wins) / Double(team2.wins + team2.losses)
                        return pct1 > pct2
                    }
                    self.westernTeams = western.sorted { team1, team2 in
                        let pct1 = Double(team1.wins) / Double(team1.wins + team1.losses)
                        let pct2 = Double(team2.wins) / Double(team2.wins + team2.losses)
                        return pct1 > pct2
                    }
                    self.isLoading = false
                case .failure(let error):
                    self.errorMessage = "Failed to fetch standings: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
}

// MARK: - Standings Section View
struct ConferenceSection: View {
    let title: String
    let teams: [StandingsTeam]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .tracking(0.3)
                .padding(.horizontal)
                .padding(.bottom, 4)

            VStack(spacing: 1) {
                // Column Headers
                StandingsHeader()

                ForEach(Array(teams.enumerated()), id: \.offset) { index, team in
                    StandingRow(
                        rank: "\(index + 1)",
                        team: team.name, // Use only the nickname
                        wins: "\(team.wins)",
                        losses: "\(team.losses)"
                    )
                }
            }
            .background(Color.white.opacity(0.1))
            .cornerRadius(15)
            .padding(.horizontal)
        }
    }
}

// Supporting view for standings header
struct StandingsHeader: View {
    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 12) {
                Text("")
                    .frame(width: 25, alignment: .leading)
                Text("")
                    .frame(width: 25)
                Text("Team")
                    .frame(width: 120, alignment: .leading)
                    .padding(.leading, -37)  // Align with team names
            }
            Spacer()
            HStack(spacing: 15) {
                Text("W")
                    .frame(width: 25)
                Text("L")
                    .frame(width: 25)
                Text("PCT")
                    .frame(width: 45)
            }
        }
        .foregroundColor(.white.opacity(0.6))
        .fontWeight(.bold)
        .padding(.vertical, 8)
        .padding(.horizontal)
        .background(Color.black.opacity(0.08))
    }
}

// Supporting view for standings row
struct StandingRow: View {
    let rank: String
    let team: String
    let wins: String
    let losses: String
    
    private var winningPercentage: String {
        guard let winsInt = Int(wins), let lossesInt = Int(losses) else { return ".000" }
        let total = Double(winsInt + lossesInt)
        let percentage = Double(winsInt) / total
        return String(format: ".%03d", Int(percentage * 1000))
    }
    
    private func getLogoName(for teamName: String) -> String {
        let lowercasedName = teamName.lowercased()
        
        // Special cases
        if lowercasedName == "76ers" {
            return "philadelphia-76ers-logo"
        }
        
        if lowercasedName.contains("trail") || lowercasedName.contains("blaz") {
            return "portland-trailblazers-logo"
        }
        
        // Map team nicknames to city names
        let cityMapping: [String: String] = [
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
        
        if let cityName = cityMapping[lowercasedName] {
            if cityName == "los-angeles" {
                return "los-angeles-\(lowercasedName)-logo"
            }
            return "\(cityName)-\(lowercasedName)-logo"
        }
        
        return "\(lowercasedName)-logo"
    }
    
    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 12) {
                Text(rank + "")
                    .frame(width: 25, alignment: .leading)
                    .foregroundColor(.white.opacity(0.7))
                    .font(.system(size: 15.5, weight: .medium))
                    .monospacedDigit()
                
                Image(getLogoName(for: team))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 33, height: 33)
                
                Text(team)
                    .frame(width: 120, alignment: .leading)
                    .font(.system(size: 15.5, weight: .semibold))
                    .tracking(0.2)
                    .minimumScaleFactor(0.8)
            }
            Spacer()
            HStack(spacing: 15) {
                Text(wins)
                    .frame(width: 25)
                    .font(.system(size: 15, weight: .medium))
                    .monospacedDigit()
                Text(losses)
                    .frame(width: 25)
                    .font(.system(size: 15, weight: .medium))
                    .monospacedDigit()
                Text(winningPercentage)
                    .frame(width: 45)
                    .font(.system(size: 15, weight: .medium))
                    .monospacedDigit()
            }
        }
        .foregroundColor(.white)
        .padding(.vertical, 8)
        .padding(.horizontal)
        .background(Color.white.opacity(0.05))
    }
}

// MARK: - Preview
struct StandingsView_Previews: PreviewProvider {
    static var previews: some View {
        StandingsView()
            .preferredColorScheme(.dark)
    }
}
