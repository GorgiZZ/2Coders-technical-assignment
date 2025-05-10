//
//  TMDB API Manager.swift
//  TMDB-2Coders
//
//  Created by Gjorgji Zhupan on 9.5.25.
//

import Foundation

class TMDBAPIManager {
    private static let router = TMDBRouter()
}

// MARK: - Trending Movies
extension TMDBAPIManager {
    static func getTrendingMovies<T: Codable>() async throws -> T {
        return try await executeGetRequest(router.urlRequest(for: .TrendingMovies))
    }
    
    static func getGenres<T: Codable>() async throws -> T {
        return try await executeGetRequest(router.urlRequest(for: .MovieGenres))
    }
    
    static func executeGetRequest<T: Codable>(_ urlRequest: URLRequest) async throws -> T {
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
