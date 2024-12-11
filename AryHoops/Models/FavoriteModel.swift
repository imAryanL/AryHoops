import Foundation
import SwiftUI

struct FavoriteTeam: Identifiable {
    let id = UUID()
    let name: String
    let conference: String
    let division: String
    let wins: Int
    let losses: Int
    let winPercentage: Double
    let streak: String
    let lastTenGames: String
    
    var imageAssetName: String {
        // Special cases for teams with different naming patterns
        let normalizedName = name.lowercased()
        switch normalizedName {
        case "la clippers":
            return "los-angeles-clippers"
        case "portland trail blazers":
            return "portland-trailblazers"
        default:
            return normalizedName.replacingOccurrences(of: " ", with: "-")
        }
    }
    
    // Initialize with StandingsTeam data
    init(from standingsTeam: StandingsTeam, conference: String, division: String) {
        self.name = "\(standingsTeam.market) \(standingsTeam.name)"  // Combine market and name
        self.conference = conference
        self.division = division
        self.wins = standingsTeam.wins
        self.losses = standingsTeam.losses
        self.winPercentage = standingsTeam.winPct
        
        // Format streak nicely (e.g., "Won 3" or "Lost 2")
        let streakKind = standingsTeam.streak.kind == "win" ? "Won" : "Lost"
        self.streak = "\(streakKind) \(standingsTeam.streak.length)"
        
        // Get last 10 games from records
        if let last10 = standingsTeam.records.first(where: { $0.recordType == "last_10" }) {
            self.lastTenGames = "\(last10.wins)-\(last10.losses)"
        } else {
            self.lastTenGames = "N/A"
        }
    }
    
    // Default initializer for placeholder data
    init(name: String, conference: String, division: String, wins: Int = 0, losses: Int = 0, winPercentage: Double = 0.0, streak: String = "", lastTenGames: String = "") {
        self.name = name
        self.conference = conference
        self.division = division
        self.wins = wins
        self.losses = losses
        self.winPercentage = winPercentage
        self.streak = streak
        self.lastTenGames = lastTenGames
    }
}

@MainActor
class FavoriteViewModel: ObservableObject {
    @Published var selectedTeam: FavoriteTeam?
    @Published var isTeamSelected = false
    @Published var allTeams: [FavoriteTeam] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    init() {
        loadPlaceholderData()
        Task {
            await fetchTeamData()
        }
    }
    
    private func loadPlaceholderData() {
        allTeams = [
            FavoriteTeam(name: "Boston Celtics", conference: "Eastern", division: "Atlantic"),
            FavoriteTeam(name: "Los Angeles Lakers", conference: "Western", division: "Pacific")
        ]
    }
    
    func fetchTeamData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
                StandingsAPI.shared.fetchStandings { result in
                    switch result {
                    case .success((let eastern, let western)):
                        DispatchQueue.main.async {
                            var teams: [FavoriteTeam] = []
                            
                            // Process Eastern Conference teams
                            for team in eastern {
                                teams.append(FavoriteTeam(
                                    from: team,
                                    conference: "Eastern",
                                    division: team.gamesBehind.division < 0 ? "Unknown" : self.getDivisionName(team: team)
                                ))
                            }
                            
                            // Process Western Conference teams
                            for team in western {
                                teams.append(FavoriteTeam(
                                    from: team,
                                    conference: "Western",
                                    division: team.gamesBehind.division < 0 ? "Unknown" : self.getDivisionName(team: team)
                                ))
                            }
                            
                            self.allTeams = teams.sorted { $0.winPercentage > $1.winPercentage }
                            self.isLoading = false
                        }
                        continuation.resume()
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.errorMessage = error.localizedDescription
                            self.isLoading = false
                        }
                        continuation.resume(throwing: error)
                    }
                }
            }
        } catch {
            self.errorMessage = error.localizedDescription
            self.isLoading = false
        }
    }
    
    private func getDivisionName(team: StandingsTeam) -> String {
        // Map division based on team's location or other criteria
        switch team.market {
        case "Boston", "Brooklyn", "New York", "Philadelphia", "Toronto":
            return "Atlantic"
        case "Chicago", "Cleveland", "Detroit", "Indiana", "Milwaukee":
            return "Central"
        case "Atlanta", "Charlotte", "Miami", "Orlando", "Washington":
            return "Southeast"
        case "Denver", "Minnesota", "Oklahoma City", "Portland", "Utah":
            return "Northwest"
        case "Golden State", "Los Angeles", "Phoenix", "Sacramento":
            return "Pacific"
        case "Dallas", "Houston", "Memphis", "New Orleans", "San Antonio":
            return "Southwest"
        default:
            return "Unknown"
        }
    }
    
    func selectTeam(_ team: FavoriteTeam) {
        self.selectedTeam = team
        self.isTeamSelected = true
    }
    
    func clearSelection() {
        self.selectedTeam = nil
        self.isTeamSelected = false
    }
}
