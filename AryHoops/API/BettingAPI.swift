//
//  BettingAPI.swift
//  AryHoops
//
//  Created by aryan on 12/10/24.
//

import Foundation

class BettingAPI {
    static let shared = BettingAPI()
    private init() {}

    // Function to fetch betting data
    func fetchBettingData(completion: @escaping (Result<[OddsResponse], Error>) -> Void) {
        let urlString = "https://api.the-odds-api.com/v4/sports/basketball_nba/odds/?apiKey=5f9462cb2d76f997969ddb229b3ad42a&regions=us&markets=h2h,totals,spreads&oddsFormat=decimal"
        
        // Safely unwrap the URL
        guard let url = URL(string: urlString) else {
            completion(.failure(APIError.invalidURL))
            return
        }

        // Start the data task
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Check for network or server error
            if let error = error {
                completion(.failure(error))
                return
            }

            // Ensure valid HTTP response
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                completion(.failure(APIError.invalidResponse(statusCode: httpResponse.statusCode)))
                return
            }

            // Ensure data is not nil
            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }

            // Attempt to decode the response
            do {
                let odds = try JSONDecoder().decode([OddsResponse].self, from: data)
                completion(.success(odds))
            } catch {
                completion(.failure(APIError.decodingError(error)))
            }
        }.resume()
    }
}

// MARK: - API Error Enum
enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse(statusCode: Int)
    case noData
    case decodingError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid. Please check the endpoint."
        case .invalidResponse(let statusCode):
            return "Received invalid response from the server. Status code: \(statusCode)."
        case .noData:
            return "No data was received from the server."
        case .decodingError(let error):
            return "Failed to decode the response: \(error.localizedDescription)"
        }
    }
}
