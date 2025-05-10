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
    
    @State var viewModel: TrendingMoviesViewModel?
    
    // MARK: UI Helper
    @State private var columns: Int = 2
    private let aspectRatio: CGFloat =  4 / 3
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ScrollView {
                    LazyVGrid(columns: (0..<columns).map { _ in GridItem(.flexible()) }) {
                        ForEach(trendingMovies, id: \.id) { movie in
                            MovieGridItemView(movie: movie)
                                .frame(height: geo.size.width / CGFloat(columns) * aspectRatio)
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            viewModel = TrendingMoviesViewModel(modelContext: modelContext)
            columns = numberOfColumnsFor(orientation: UIDevice.current.orientation)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            columns = numberOfColumnsFor(orientation: UIDevice.current.orientation)
        }
    }
}

private extension TrendingMoviesView {
    func numberOfColumnsFor(orientation: UIDeviceOrientation) -> Int {
        switch orientation {
        case .portrait, .portraitUpsideDown, .faceUp, .faceDown:
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
