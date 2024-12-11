//
//  StandingsAPI.swift
//  AryHoops
//
//  Created by aryan on 12/6/24.
//

import Foundation

class StandingsAPI {
    static let shared = StandingsAPI()
    private init() {}

    private let apiKey = "JBRGUIsDe1lgyYOHaw6LHLsPoISsLQfmP8DqAA9A"
    private let baseURL = "https://api.sportradar.com/nba/trial/v8/en/seasons/2024/REG/standings.json"

    // Fetch Standings
    func fetchStandings(completion: @escaping (Result<([StandingsTeam], [StandingsTeam]), Error>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }

        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        components.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.timeoutInterval = 10

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
                // Decode the JSON data into the `Standings` model
                let standings = try JSONDecoder().decode(Standings.self, from: data)
                
                // Extract Eastern and Western conference teams
                let easternTeams = standings.conferences
                    .first(where: { $0.name.uppercased() == "EASTERN CONFERENCE" })?
                    .divisions
                    .flatMap { $0.teams } ?? []
                
                let westernTeams = standings.conferences
                    .first(where: { $0.name.uppercased() == "WESTERN CONFERENCE" })?
                    .divisions
                    .flatMap { $0.teams } ?? []
                
                // Return sorted results
                completion(.success((
                    easternTeams.sorted { $0.wins > $1.wins },
                    westernTeams.sorted { $0.wins > $1.wins }
                )))
            } catch {
                print("Decoding Error: \(error)")
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
