//
//  ImageManager.swift
//  TMDB-2Coders
//
//  Created by Gjorgji Zhupan on 10.5.25.
//

import Foundation
import SwiftData
import UIKit

enum ImageSize: String {
    case w500
}

final class ImageManager: TMDBRouter {
    private static let router = ImageRouter()
    
    static func getImage(at path: String) async throws -> UIImage {
        let (imageData, _) = try await URLSession.shared.data(for: router.urlRequestForImage(at: path))
        
        guard let uiImage = UIImage(data: imageData)
        else { throw ImageManagerError.InvalidImageData }
        
        return uiImage
    }
}

private class ImageRouter: TMDBRouter {
    private let imageURL: String = "https://image.tmdb.org/t/p/"
    
    func urlRequestForImage(at path: String,
                            forSize size: ImageSize = .w500) throws -> URLRequest {
        guard let url = URL(string: imageURL + size.rawValue + path)
        else { throw TMDBRouterError.InvalidURL }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.timeoutInterval = 10
        urlRequest.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer " + getApiToken()
        ]
        
        return urlRequest
    }
}

enum ImageManagerError: LocalizedError {
    case InvalidImageData
    
    var errorDescription: String? {
        switch self {
        case .InvalidImageData:
            return "Image data was in bad format"
        }
    }
}
