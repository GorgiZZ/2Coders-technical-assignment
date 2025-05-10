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
    var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        
        Task {
            try await getTrendingMovies()
        }
    }
    
    private func getTrendingMovies() async throws {
        let response = try await TMDBAPIManager.getTrendingMovies()
        
        self.currentPage = response.page // TODO: Use in request, but it seems it's not supported in API?
        let movies = response.results
        
        movies.forEach {
            modelContext.insert($0)
        }
        
        try modelContext.save()
    }
}
