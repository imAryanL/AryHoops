//
//  StandingsModel.swift
//  AryHoops
//
//  Created by aryan on 12/6/24.
//

import Foundation

// MARK: - Standings Model

struct Standings: Codable {
    let league: League
    let season: Season
    let conferences: [Conference]
}

struct League: Codable {
    let id: String
    let name: String
    let alias: String
}

struct Season: Codable {
    let id: String
    let year: Int
    let type: String
}

struct Conference: Codable {
    let id: String
    let name: String
    let alias: String
    let divisions: [Division]
}

struct Division: Codable {
    let id: String
    let name: String
    let alias: String
    let teams: [StandingsTeam]
}

struct StandingsTeam: Codable {
    let id: String
    let name: String
    let market: String
    let wins: Int
    let losses: Int
    let winPct: Double
    let pointsFor: Double
    let pointsAgainst: Double
    let pointDiff: Double
    let srId: String
    let reference: String
    let gamesBehind: GamesBehind
    let streak: Streak
    let calcRank: CalcRank
    let records: [Record]

    enum CodingKeys: String, CodingKey {
        case id, name, market, wins, losses
        case winPct = "win_pct"
        case pointsFor = "points_for"
        case pointsAgainst = "points_against"
        case pointDiff = "point_diff"
        case srId = "sr_id"
        case reference
        case gamesBehind = "games_behind"
        case streak
        case calcRank = "calc_rank"
        case records
    }
}

struct GamesBehind: Codable {
    let league: Double
    let conference: Double
    let division: Double
}

struct Streak: Codable {
    let kind: String
    let length: Int
}

struct CalcRank: Codable {
    let divRank: Int
    let confRank: Int

    enum CodingKeys: String, CodingKey {
        case divRank = "div_rank"
        case confRank = "conf_rank"
    }
}

struct Record: Codable {
    let recordType: String
    let wins: Int
    let losses: Int
    let winPct: Double

    enum CodingKeys: String, CodingKey {
        case recordType = "record_type"
        case wins, losses
        case winPct = "win_pct"
    }
}
