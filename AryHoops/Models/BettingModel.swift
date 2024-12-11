//
//  BettingModel.swift
//  AryHoops
//
//  Created by aryan on 12/10/24.
//

import Foundation

// Main response model
struct OddsResponse: Codable {
    let id: String
    let sportTitle: String
    let commenceTime: String
    let homeTeam: String
    let awayTeam: String
    let bookmakers: [Bookmaker]

    enum CodingKeys: String, CodingKey {
        case id
        case sportTitle = "sport_title"
        case commenceTime = "commence_time"
        case homeTeam = "home_team"
        case awayTeam = "away_team"
        case bookmakers
    }
    
    // Helper function to get team nickname
    func getTeamNickname(_ fullName: String) -> String {
        let components = fullName.components(separatedBy: " ")
        return components.last ?? fullName
    }
    
    var homeTeamNickname: String {
        getTeamNickname(homeTeam)
    }
    
    var awayTeamNickname: String {
        getTeamNickname(awayTeam)
    }
}

// Bookmaker model
struct Bookmaker: Codable {
    let title: String // Name of the bookmaker (e.g., FanDuel)
    let markets: [Market]
}

// Market model
struct Market: Codable {
    let key: String // h2h (moneyline), spreads, totals
    let outcomes: [Outcome]
}

// Outcome model
struct Outcome: Codable {
    let name: String // Team name (for h2h) or "Over"/"Under" (for totals)
    let price: Double // Odds in decimal format
    let point: Double? // Spread points or total points, optional for h2h
}
