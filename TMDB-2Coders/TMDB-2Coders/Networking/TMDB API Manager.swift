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
    static func getTrendingMovies() async throws -> TMDBResponse<Movie> {
        let urlRequest = try router.urlRequest(for: .TrendingMovies)
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        return try JSONDecoder().decode(TMDBResponse<Movie>.self, from: data)
    }
}
