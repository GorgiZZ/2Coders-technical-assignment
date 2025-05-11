//
//  CompactMovieItemView.swift
//  TMDB-2Coders
//
//  Created by Gjorgji Zhupan on 10.5.25.
//

import SwiftUI

struct CompactMovieItemView: View {
    @ObservedObject var movie: Movie
    
    var body: some View {
        ZStack {
            GeometryReader { geo in // Read the cell's size
                Group {
                    if movie.isLoadingImage {
                        ProgressView()
                            .progressViewStyle(.circular)
                    } else {
                        if let uiImage = movie.uiImage {
                            Image(uiImage: uiImage)
                                .resizable()
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                        }
                    }
                }
                .aspectRatio(contentMode: .fill)
                // Set the frame to avoid different sizes
                .frame(width: geo.size.width,
                       height: geo.size.height)
            }
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Text(movie.title)
                        .font(.system(size: 18, weight: .semibold))
                    
                    Spacer()
                }
            }
            .foregroundStyle(.white)
            .padding()
            .allowsHitTesting(false) // Pass touches to the view below
            .background {
                LinearGradient(colors:(0..<3).map { _ in Color.clear } +
                               (0..<2).map { _ in Color.black.opacity(0.8) },
                               startPoint: .top,
                               endPoint: .bottom)
            }
        }
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(lineWidth: 3)
                .fill(.gray)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    CompactMovieItemView(movie: .dummy())
}
