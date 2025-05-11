//
//  TMDB_2CodersApp.swift
//  TMDB-2Coders
//
//  Created by Gjorgji Zhupan on 9.5.25.
//

import SwiftUI
import SwiftData

@main
struct TMDB_2CodersApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Movie.self,
            MovieGenre.self,
            ImageCacheItem.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            let modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            // Setting the same model context to ensure no conflicts arise when saving ImageCacheItems
            ImageManager.shared.modelContext = modelContainer.mainContext
            
            return modelContainer
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            TrendingMoviesView()
        }
        .modelContainer(sharedModelContainer)
    }
}
