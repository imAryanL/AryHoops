//
//  ScheduleModel.swift
//  AryHoops
//
//  Created by aryan on 12/6/24.
//

import Foundation

// Root structure for the API response
struct ScheduleResponse: Decodable {
    let league: ScheduleLeague
    let season: ScheduleSeason
    let games: [ScheduleGame]
}

// League details
struct ScheduleLeague: Decodable {
    let id: String
    let name: String
    let alias: String
}

// Season details
struct ScheduleSeason: Decodable {
    let id: String
    let year: Int
    let type: String
}

// Game details
struct ScheduleGame: Decodable {
    let id: String
    let status: String
    let coverage: String
    let scheduled: String // ISO date format
    let homePoints: Int?
    let awayPoints: Int?
    let venue: ScheduleVenue
    let broadcasts: [ScheduleBroadcast]?
    let home: ScheduleTeam
    let away: ScheduleTeam
    
    enum CodingKeys: String, CodingKey {
        case id, status, coverage, scheduled, venue, broadcasts, home, away
        case homePoints = "home_points"
        case awayPoints = "away_points"
    }
}

// Venue details
struct ScheduleVenue: Decodable {
    let id: String
    let name: String
    let capacity: Int?
    let address: String?
    let city: String
    let state: String? // Marking state as optional
    let zip: String?
    let country: String
    let location: ScheduleLocation?
}

// Location details (latitude and longitude)
struct ScheduleLocation: Decodable {
    let lat: String
    let lng: String
}

// Broadcast details
struct ScheduleBroadcast: Decodable {
    let network: String
    let type: String
    let locale: String? // Marking locale as optional
    let channel: String?
}

// Team details
struct ScheduleTeam: Decodable {
    let name: String
    let alias: String
    let id: String
}
