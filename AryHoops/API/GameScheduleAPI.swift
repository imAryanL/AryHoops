//
//  GameScheduleAPI.swift
//  AryHoops
//
//  Created by aryan on 12/6/24.
//

import Foundation

class GameScheduleAPI {
    static let shared = GameScheduleAPI()
    private init() {}

    private let apiKey = "JBRGUIsDe1lgyYOHaw6LHLsPoISsLQfmP8DqAA9A"
    private let baseURL = "https://api.sportradar.com/nba/trial/v8/en/games/2024/REG/schedule.json"

    // Fetch the next 5 upcoming games
    func fetchUpcomingGames(completion: @escaping (Result<[ScheduleGame], Error>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }

        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]

        guard let finalURL = components.url else {
            completion(.failure(NSError(domain: "Invalid URL Components", code: 400, userInfo: nil)))
            return
        }

        let request = URLRequest(url: finalURL)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(NSError(domain: "Invalid response", code: 500, userInfo: nil)))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 404, userInfo: nil)))
                return
            }

            do {
                // Decode the JSON response
                let scheduleResponse = try JSONDecoder().decode(ScheduleResponse.self, from: data)

                // Filter games that have not yet started
                let now = Date()
                let upcomingGames = scheduleResponse.games.filter { game in
                    if let gameDate = ISO8601DateFormatter().date(from: game.scheduled) {
                        return gameDate > now && game.status.lowercased() == "scheduled"
                    }
                    return false
                }

                // Return the first 5 upcoming games
                completion(.success(Array(upcomingGames.prefix(5))))
            } catch {
                print("Decoding Error: \(error)")
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
