//
//  PlayerStatsAPI.swift
//  AryHoops
//
//  Created by aryan on 12/6/24.
//

import Foundation

class LeaderboardAPI {
    static let shared = LeaderboardAPI()
    private let apiKey = "JBRGUIsDe1lgyYOHaw6LHLsPoISsLQfmP8DqAA9A"
    private let baseURL = "https://api.sportradar.com/nba/trial/v8/en/seasons/2024/REG/leaders.json"
    
    private init() {}
    
    /// Fetches league leaders from the API
    func fetchLeaders(completion: @escaping (Result<[Category], Error>) -> Void) {
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
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 404, userInfo: nil)))
                return
            }
            
            // Log raw data for debugging
            print("Raw JSON Response: \(String(data: data, encoding: .utf8) ?? "No Data")")
            
            do {
                let leaderboardResponse = try JSONDecoder().decode(LeaderboardResponse.self, from: data)
                completion(.success(leaderboardResponse.categories))
            } catch {
                print("Decoding Error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
