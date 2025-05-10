//
//  TrendingMoviesView.swift
//  TMDB-2Coders
//
//  Created by Gjorgji Zhupan on 10.5.25.
//

import SwiftUI
import SwiftData

struct TrendingMoviesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var trendingMovies: [Movie]
    
    @State var viewModel: TrendingMoviesViewModel = TrendingMoviesViewModel()
    
    // MARK: UI Helper
    @State private var columns: Int = 2
    private let aspectRatio: CGFloat =  4 / 3
    
    var body: some View {
        // TODO: Add a search bar
        
        // TODO: Add compact / expanded view
        // Use MovieGridItemView for compact
        // Use a view similar to Details' horizontal layout for epanded
        NavigationStack {
            GeometryReader { geo in
                ScrollView {
                    LazyVGrid(columns: (0..<columns).map { _ in GridItem(.flexible()) }) {
                        ForEach(trendingMovies, id: \.id) { movie in
                            NavigationLink {
                                MovieDetailsView(movie: movie) //, modelContext: modelContext)
                            } label: {
                                // TODO: Change depending on compact / expanded
                                MovieGridItemView(movie: movie)
                                    .frame(height: geo.size.width / CGFloat(columns) * aspectRatio)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Trending movies")
            .navigationBarTitleDisplayMode(.automatic)
        }
        .onAppear {
            // Setting the context instead of initializing the viewModel prevents unnecessary requests
            viewModel.modelContext = modelContext
            
            columns = numberOfColumnsFor(orientation: UIDevice.current.orientation)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            // Don't react to face up/down
            guard ![UIDeviceOrientation.faceUp, .faceDown].contains(UIDevice.current.orientation)
            else { return }
            
            columns = numberOfColumnsFor(orientation: UIDevice.current.orientation)
        }
    }
}

private extension TrendingMoviesView {
    func numberOfColumnsFor(orientation: UIDeviceOrientation) -> Int {
        switch orientation {
        case .portrait, .portraitUpsideDown:
            return 2
        case .landscapeLeft, .landscapeRight:
            return 3
        default:
            return 2
        }
    }
}

#Preview {
    TrendingMoviesView()
        .modelContainer(for: Movie.self, inMemory: true)
}
