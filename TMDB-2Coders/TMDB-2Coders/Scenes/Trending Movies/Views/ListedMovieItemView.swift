//
//  ListedMovieItemView.swift
//  TMDB-2Coders
//
//  Created by Gjorgji Zhupan on 10.5.25.
//

import SwiftUI
import SwiftData

struct ListedMovieItemView: View {
    let movie: Movie
    
    @State private var isLoadingImage: Bool = true
    @State private var uiImage: UIImage?
    
    var body: some View {
        HStack(alignment: .top) {
            posterImageView
            .frame(minWidth: 64, maxWidth: 128) // TODO: Get screen size dynamically
            
            // GeometryReader moves views around
            VStack(alignment: .leading, spacing: 8) {
                Text(movie.title)
                    .font(.system(size: 24, weight: .bold))
                
                HStack(spacing: 0) {
                    Text("\(String(format: "%.1f", movie.voteAverage)) / 10")
                    
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                }
                .font(.system(size: 18))
                
                Text(movie.overview)
                    .lineLimit(5)
            }
            .multilineTextAlignment(.leading)
        }
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(lineWidth: 3)
                .fill(.gray)
        }
        .padding()
        .onAppear {
            isLoadingImage = true
            Task {
                defer { isLoadingImage = false }
                
                // TODO: Implement image cache
                let image = try await ImageManager.getImage(at: movie.posterPath)
                await MainActor.run { self.uiImage = image }
            }
        }
    }
    
    // MARK: Elements
    private var posterImageView: some View {
        GeometryReader { geo in
            Group {
                if isLoadingImage {
                    ProgressView()
                        .progressViewStyle(.circular)
                } else {
                    if let uiImage {
                        Image(uiImage: uiImage)
                            .resizable()
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                    }
                }
            }
            .aspectRatio(contentMode: .fill)
            .frame(width: geo.size.width,
                   height: geo.size.height)
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    ListedMovieItemView(movie: .dummy())
}
