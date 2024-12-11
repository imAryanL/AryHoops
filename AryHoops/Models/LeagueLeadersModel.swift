//
//  PlayerStatsModel.swift
//  AryHoops
//
//  Created by aryan on 12/6/24.
//

import Foundation

// Top-level response
struct LeaderboardResponse: Decodable {
    let season: Season
    let id: String
    let name: String
    let alias: String
    let type: String
    let categories: [Category] // This is where your leaders are
}

// Season details
struct LeagueSeason: Decodable {
    let id: String
    let year: Int
    let type: String
}

// Category for stats
struct Category: Decodable {
    let name: String // e.g., "minutes"
    let type: String // e.g., "total" or "average"
    let ranks: [LeaderRank]
}

// Player rank in a category
struct LeaderRank: Decodable {
    let rank: Int
    let score: Double
    let player: Player
    let teams: [LeaderTeam]
    let total: TotalStats?
    let average: AverageStats?
}

// Player details
struct Player: Decodable {
    let id: String
    let full_name: String
    let position: String
}

// Team details
struct LeaderTeam: Decodable {
    let id: String
    let name: String
    let market: String
}

// Average stats for a player
struct AverageStats: Decodable {
    let minutes: Double?
    let points: Double?
    let rebounds: Double?
    let assists: Double?
    let steals: Double?
    let blocks: Double?
    let free_throws_made: Double?
    let three_points_made: Double?
}

// Total stats for a player
struct TotalStats: Decodable {
    let games_played: Int
    let games_started: Int
    let points: Int?
    let rebounds: Int?
    let assists: Int?
    let steals: Int?
    let blocks: Int?
    let free_throws_made: Int?
    let three_points_made: Int?
}
