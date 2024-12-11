//
//  LiveScoreModel.swift
//  AryHoops
//
//  Created by aryan on 12/6/24.
//

import Foundation

// Root structure for the API response
struct LiveGamesResponse: Decodable {
    let get: String
    let parameters: Parameters
    let errors: [String]
    let results: Int
    let response: [LiveGameResponse]
}

struct Parameters: Decodable {
    let live: String
}

// Live game details
struct LiveGameResponse: Decodable {
    let id: Int
    let league: String
    let season: Int
    let date: GameDate
    let stage: Int
    let status: GameStatus
    let periods: GamePeriods
    let arena: Arena
    let teams: GameTeams
    let scores: GameScores
}

// Game date details
struct GameDate: Decodable {
    let start: String
    let end: String?
    let duration: String?
}

// Game status details
struct GameStatus: Decodable {
    let clock: String?
    let halftime: Bool
    let short: Int
    let long: String
}

// Game periods details
struct GamePeriods: Decodable {
    let current: Int
    let total: Int
    let endOfPeriod: Bool
}

// Arena details
struct Arena: Decodable {
    let name: String
    let city: String
    let state: String
    let country: String?
}

// Teams involved in the game
struct GameTeams: Decodable {
    let visitors: Team
    let home: Team
}

// Team details
struct Team: Decodable {
    let id: Int
    let name: String
    let nickname: String
    let code: String
    let logo: String
}

// Game scores
struct GameScores: Decodable {
    let visitors: TeamScore
    let home: TeamScore
}

// Team score details
struct TeamScore: Decodable {
    let win: Int
    let loss: Int
    let series: SeriesScore
    let linescore: [String]
    let points: Int
}

// Series score details
struct SeriesScore: Decodable {
    let win: Int
    let loss: Int
}
