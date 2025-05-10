//
//  TrendingMoviesViewModel.swift
//  TMDB-2Coders
//
//  Created by Gjorgji Zhupan on 10.5.25.
//

import Foundation
import SwiftData
import os

class TrendingMoviesViewModel {
    private(set) var currentPage: Int = 0
    var modelContext: ModelContext?
    
    init() {
        Task {
            try await getTrendingMovies()
        }
        
        Task {
            try await getGenres()
        }
    }
    
    private func getTrendingMovies() async throws {
        let response: TMDBResponse<Movie> = try await TMDBAPIManager.getTrendingMovies()
        
        self.currentPage = response.page // TODO: Use in request, but it seems it's not supported in API?
        let movies = response.results
        
        movies.forEach {
            modelContext?.insert($0)
        }
        
        try modelContext?.save()
    }
    
    private func getGenres() async throws {
        let genres: [String: [MovieGenre]] = try await TMDBAPIManager.getGenres()
        
        (genres["genres"] ?? []).forEach {
            modelContext?.insert($0)
        }
        
        try modelContext?.save()
    }
}
