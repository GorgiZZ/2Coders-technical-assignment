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
    var genreIDs: [Int]
    var popularity: Double = 0
    var releaseDate: String
    var video: Bool = true
    var voteAverage: Double = 0
    var voteCount: Int = 0
    
    /// The movie's releaseDate, reformatted as dd.MM.yyyy
    var formattedReleaseDate: String {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = inputDateFormatter.date(from: releaseDate)
        else { return "N/A" }
        
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "dd.MM.yyyy"
        return outputDateFormatter.string(from: date)
    }
    
    /// Fetches the genres from the context that match the IDs in this movie, then concatenates their names in a single String
    func genreNames(using context: ModelContext) -> String? {
        let predicate = #Predicate<MovieGenre> { genreIDs.contains($0.id) }
        let fetchDescriptor = FetchDescriptor(predicate: predicate)
        
        guard let genres = try? context.fetch(fetchDescriptor)
        else { return nil }
        
        var result: String = ""
        genres.map { $0.name }.forEach {
            result.append($0 + ", ")
        }
        result.removeLast(result.count >= 2 ? 2 : 0)
        return result
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

// MARK: - Helper
extension Movie {
    static func dummy() -> Movie {
        return Movie(backdropPath: "",
                     title: "Test Movie",
                     originalLanguage: "",
                     originalTitle: "Test Movie 2",
                     overview: """
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean feugiat varius vulputate. Mauris maximus ex at purus semper, eget efficitur ligula mollis. Sed laoreet, metus nec posuere iaculis, massa dui auctor ipsum, non dignissim libero ex non dolor. In hac habitasse platea dictumst. Donec ut tincidunt leo. Nulla id lectus neque. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque quis ipsum tincidunt, dignissim sem sed, tincidunt eros. Aliquam erat volutpat. Fusce blandit imperdiet facilisis. Proin dapibus at mi non egestas. Morbi mattis est eu tristique vulputate. Morbi sit amet ante eget diam auctor varius.

Curabitur cursus ex ut velit faucibus efficitur. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Donec tortor lorem, malesuada vel metus nec, volutpat cursus ante. Pellentesque magna lectus, accumsan vitae est a, ultricies facilisis turpis. Aenean eget laoreet felis. Morbi elementum dui augue. Aliquam venenatis iaculis magna ac cursus. Etiam lobortis felis at nisl dignissim, non rhoncus elit eleifend. Integer pellentesque sem purus, eu elementum magna dictum eu. Donec tellus massa, dictum ac nisi tempor, condimentum mattis sem. Fusce fringilla interdum justo quis tempus. Cras sed semper urna, nec eleifend erat. Duis a nisl tincidunt, lacinia elit sed, varius nibh. Cras efficitur tincidunt mauris vitae tempor.

In vestibulum orci sapien, quis rutrum lacus egestas eu. Nullam ultrices justo et nisi aliquam, sit amet auctor dui elementum. Nunc eget magna velit. Aenean ac bibendum massa. Morbi consequat aliquam ligula, ut scelerisque tortor finibus non. Pellentesque fringilla leo non risus cursus, nec aliquet sapien auctor. Nulla ultrices feugiat ex a aliquam. Donec quam lacus, tempor venenatis metus eu, sagittis aliquet nibh. Donec dictum lorem quis dui lobortis ornare. Donec bibendum eget enim in consequat. Nunc porta metus tellus, ut fermentum nisi tempor ut. Sed purus dui, elementum sed felis eu, euismod pellentesque enim. Phasellus sed condimentum metus. In consectetur bibendum odio at fermentum. Sed pharetra leo vel eleifend scelerisque.

Nunc interdum et eros eu faucibus. Quisque nec interdum elit. Maecenas interdum accumsan dolor, et eleifend turpis tincidunt a. Cras pretium commodo elementum. Etiam euismod scelerisque posuere. Proin a nibh eget erat dictum cursus non ultricies magna. In molestie malesuada sagittis. Donec aliquam, lacus non efficitur dapibus, nulla sem feugiat neque, vitae gravida nulla nunc nec sem. Mauris quis dui sem. Duis rutrum felis a eros auctor sollicitudin. Sed eu tortor nisi. Aenean aliquet cursus urna, tristique lacinia turpis eleifend aliquam. Suspendisse malesuada a turpis eget imperdiet. Vivamus condimentum eleifend libero, non aliquet urna varius quis.

Donec tempus bibendum iaculis. Ut dictum tellus sed massa congue elementum. Nullam id rhoncus lorem, at pharetra mi. Maecenas bibendum consequat massa, a ullamcorper eros molestie in. Nulla facilisi. Praesent orci leo, mollis vel nibh in, efficitur ultricies dui. Donec dictum hendrerit nisi, at hendrerit nunc malesuada non. Morbi varius est eget nunc iaculis, ut faucibus lacus laoreet. Sed ultrices nunc leo, a condimentum metus mattis in. Suspendisse potenti. Nunc vel diam fermentum, pellentesque massa sed, laoreet quam. Cras lobortis nunc elit, id porta quam feugiat in.


""",
                     posterPath: "",
                     mediaType: "",
                     genreIDs: [0],
                     releaseDate: "")
    }
}
