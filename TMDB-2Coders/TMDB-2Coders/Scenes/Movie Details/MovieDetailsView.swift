//
//  MovieDetailsView.swift
//  TMDB-2Coders
//
//  Created by Gjorgji Zhupan on 10.5.25.
//

import SwiftUI

struct MovieDetailsView: View {
    let movie: Movie
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var orientation: UIDeviceOrientation = UIDevice.current.orientation
    @State private var loadingPoster: Bool = true
    @State private var posterImage: UIImage?
    
    private var deviceIsInPortrait: Bool {
        switch orientation {
        case .portrait, .portraitUpsideDown:
            return true
        case .landscapeLeft, .landscapeRight:
            return false
        default:
            return true
        }
    }
    
    var body: some View {
        ScrollView {
            if deviceIsInPortrait {
                verticalLayout
            } else {
                horizontalLayout
            }
        }
        .onAppear {
            loadingPoster = true
            Task {
                defer { loadingPoster = false }
                
                // TODO: Implement image cache
                let image = try await ImageManager.getImage(at: movie.posterPath)
                await MainActor.run { self.posterImage = image }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            // Don't react to face up/down
            guard ![UIDeviceOrientation.faceUp, .faceDown].contains(UIDevice.current.orientation)
            else { return }
            orientation = UIDevice.current.orientation
        }

    }
    
    private var verticalLayout: some View {
        VStack(spacing: 8) {
            posterImageView
            
            movieTitleView
            
            ratingView
            
            Text(movie.overview)
        }
        .padding()
    }
    
    private var horizontalLayout: some View {
        HStack(alignment: .top) {
            posterImageView
            .frame(minWidth: 150, maxWidth: 250) // TODO: Get screen size dynamically
            // GeometryReader moves views around
            
            VStack(alignment: .leading, spacing: 8) {
                movieTitleView
                
                ratingView
                
                Text(movie.overview)
            }
            .padding()
        }
        .padding()
    }
    
    // MARK: Elements
    private var posterImageView: some View {
        Group {
            if loadingPoster {
                ProgressView()
                    .progressViewStyle(.circular)
            } else {
                if let posterImage {
                    Image(uiImage: posterImage)
                        .resizable()
                } else {
                    Image(systemName: "photo")
                        .resizable()
                }
            }
        }
        .aspectRatio(contentMode: .fill)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private var movieTitleView: some View {
        VStack(alignment: deviceIsInPortrait ? .center : .leading) {
            HStack {
                if movie.adult {
                    Image(systemName: "18.circle")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.black, .red)
                }
                
                Text(movie.title)
                    .font(.system(size: 24, weight: .bold))
            }
            
            if movie.title != movie.originalTitle {
                Text("Original title (\(movie.originalLanguage)): \(movie.originalTitle)")
            }
            
            if let genreNames = movie.genreNames(using: modelContext) {
                Text(genreNames)
            }
            
            Text("Released \(movie.formattedReleaseDate)")
        }
    }
    
    private var ratingView: some View {
        VStack {
            HStack(spacing: 0) {
                Text("\(String(format: "%.1f", movie.voteAverage)) / 10")
                
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
            }
            .font(.system(size: 18))
            
            Text("(\(movie.voteCount) votes)")
                .font(.system(size: 14))
        }
    }
}

#Preview {
    MovieDetailsView(movie: .dummy())
}
