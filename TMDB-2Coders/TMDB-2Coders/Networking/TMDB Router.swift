//
//  TMDB Router.swift
//  TMDB-2Coders
//
//  Created by Gjorgji Zhupan on 9.5.25.
//

import Foundation

enum TMDBAPIEndpoint {
    case TrendingMovies
    case MovieGenres
    
    var path: String {
        switch self {
        case .TrendingMovies:
            return "trending/movie/day" // TODO: Add variable time_window?
        case .MovieGenres:
            return "genre/movie/list"
        }
    }
    
    var method: String {
        switch self {
        case .TrendingMovies, .MovieGenres:
            return "GET"
        }
    }
    
    var queryItems: [URLQueryItem] {
        var queryItems: [URLQueryItem] = [URLQueryItem(name: "language", value: "en-US")]
        // TODO: Add query items per case as needed
        return queryItems
    }
}

class TMDBRouter {
    private let baseURL: String = "https://api.themoviedb.org/3/"
    
    func urlRequest(for endpoint: TMDBAPIEndpoint) throws -> URLRequest {
        guard let url = URL(string: baseURL + endpoint.path),
              var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        else { throw TMDBRouterError.InvalidURL }
        
        components.queryItems = endpoint.queryItems
        
        guard let requestURL = components.url
        else { throw TMDBRouterError.InvalidURL }
        
        var urlRequest = URLRequest(url: requestURL)
        urlRequest.httpMethod = endpoint.method
        urlRequest.timeoutInterval = 10
        urlRequest.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer " + getApiToken()
        ]
        
        return urlRequest
    }
}

// MARK: Auth
extension TMDBRouter {
    func getApiToken() -> String {
        guard let apiToken = Bundle.main.object(forInfoDictionaryKey: "API TOKEN") as? String
        else { return "" }
        
        return apiToken
    }
}

// MARK: - Errors
enum TMDBRouterError: LocalizedError {
    case InvalidURL
    
    var errorDescription: String? {
        switch self {
        case .InvalidURL:
            return "Invalid URL"
        }
    }
}
