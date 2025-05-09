//
//  Movie.swift
//  TMDB-2Coders
//
//  Created by Gjorgji Zhupan on 10.5.25.
//

import Foundation
import SwiftData

@Model
final class Movie: Codable {
    var adult: Bool = true
    var backdropPath: String
    @Attribute(.unique) var id: Int = 0
    var title: String
    var originalLanguage: String
    var originalTitle: String
    var overview: String
    var posterPath: String
    var mediaType: String // TODO: Enum
    var genreIDs: [Int] // TODO: Enum
    var popularity: Double = 0
    var releaseDate: String // TODO: Convert to date?
    var video: Bool = true
    var voteAverage: Double = 0
    var voteCount: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case id
        case title
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case genreIDs = "genre_ids"
        case popularity
        case releaseDate = "release_date"
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    // MARK: - init
    init(adult: Bool = true,
         backdropPath: String,
         id: Int = 0,
         title: String,
         originalLanguage: String,
         originalTitle: String,
         overview: String,
         posterPath: String,
         mediaType: String,
         genreIDs: [Int],
         popularity: Double = 0,
         releaseDate: String,
         video: Bool = true,
         voteAverage: Double = 0,
         voteCount: Int = 0) {
        self.adult = adult
        self.backdropPath = backdropPath
        self.id = id
        self.title = title
        self.originalLanguage = originalLanguage
        self.originalTitle = originalTitle
        self.overview = overview
        self.posterPath = posterPath
        self.mediaType = mediaType
        self.genreIDs = genreIDs
        self.popularity = popularity
        self.releaseDate = releaseDate
        self.video = video
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }
    
    // MARK: Codable
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        adult = try container.decode(Bool.self, forKey: .adult)
        backdropPath = try container.decode(String.self, forKey: .backdropPath)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        originalLanguage = try container.decode(String.self, forKey: .originalLanguage)
        originalTitle = try container.decode(String.self, forKey: .originalTitle)
        overview = try container.decode(String.self, forKey: .overview)
        posterPath = try container.decode(String.self, forKey: .posterPath)
        mediaType = try container.decode(String.self, forKey: .mediaType)
        genreIDs = try container.decode([Int].self, forKey: .genreIDs)
        popularity = try container.decode(Double.self, forKey: .popularity)
        releaseDate = try container.decode(String.self, forKey: .releaseDate)
        video = try container.decode(Bool.self, forKey: .video)
        voteAverage = try container.decode(Double.self, forKey: .voteAverage)
        voteCount = try container.decode(Int.self, forKey: .voteCount)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(adult, forKey: .adult)
        try container.encode(backdropPath, forKey: .backdropPath)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(originalLanguage, forKey: .originalLanguage)
        try container.encode(originalTitle, forKey: .originalTitle)
        try container.encode(overview, forKey: .overview)
        try container.encode(posterPath, forKey: .posterPath)
        try container.encode(mediaType, forKey: .mediaType)
        try container.encode(genreIDs, forKey: .genreIDs)
        try container.encode(popularity, forKey: .popularity)
        try container.encode(releaseDate, forKey: .releaseDate)
        try container.encode(video, forKey: .video)
        try container.encode(voteAverage, forKey: .voteAverage)
        try container.encode(voteCount, forKey: .voteCount)
    }
}
