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
    
    @State private var compactView: Bool = true
    
    // MARK: UI Helper
    @State private var columns: Int = 2
    private let aspectRatio: CGFloat =  4 / 3
    
    var body: some View {
        // TODO: Add a search bar
        
        NavigationStack {
            GeometryReader { geo in
                VStack(alignment: .trailing) {
                    // TODO: Search bar here
                    
                    Toggle("Compact view", isOn: $compactView)
                    
                    ScrollView {
                        LazyVGrid(columns: (0..<columns).map { _ in GridItem(.flexible()) }) {
                            ForEach(trendingMovies, id: \.id) { movie in
                                NavigationLink {
                                    MovieDetailsView(movie: movie)
                                } label: {
                                    if compactView {
                                        CompactMovieItemView(movie: movie)
                                            .frame(height: geo.size.width / CGFloat(columns) * aspectRatio)
                                    } else {
                                        ListedMovieItemView(movie: movie)
                                            .frame(height: geo.size.width / CGFloat(columns + 1) * aspectRatio)
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Trending movies")
            .navigationBarTitleDisplayMode(.automatic)
        }
        .onAppear {
            // Setting the context instead of initializing the viewModel prevents unnecessary requests
            viewModel.modelContext = modelContext
            
            columns = numberOfColumnsFor(orientation: UIDevice.current.orientation)
        }
        .onChange(of: compactView) { oldValue, newValue in
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
            return compactView ? 2 : 1
        case .landscapeLeft, .landscapeRight:
            return compactView ? 3 : 2
        default:
            return compactView ? 2 : 1
        }
    }
}

#Preview {
    TrendingMoviesView()
        .modelContainer(for: Movie.self, inMemory: true)
}
