//
//  LiveScoreAPI.swift
//  AryHoops
//
//  Created by aryan on 12/6/24.
//

import Foundation

class LiveScoreAPI {
    // Singleton instance
    static let shared = LiveScoreAPI()
    private init() {}

    private let apiKey = "1324dfbd99msha3edbed96dd9c09p144bb9jsn5c69293f65a0" // Replace with your RapidAPI key
    private let apiHost = "api-nba-v1.p.rapidapi.com"

    // Fetch live games
    func fetchLiveScores(completion: @escaping (Result<[LiveGameResponse], Error>) -> Void) {
        guard let url = URL(string: "https://\(apiHost)/games?live=all") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "x-rapidapi-key")
        request.setValue(apiHost, forHTTPHeaderField: "x-rapidapi-host")
        // Disable caching to always get fresh data
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0

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
                // Decode into the root object LiveGamesResponse
                let decodedResponse = try JSONDecoder().decode(LiveGamesResponse.self, from: data)
                completion(.success(decodedResponse.response))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
