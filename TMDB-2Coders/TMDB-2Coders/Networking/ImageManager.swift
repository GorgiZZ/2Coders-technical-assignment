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
    // TODO: Get sizes from calling the /configuration request
    case thumbnail = "w92"
    case full = "original"
}

final class ImageManager: TMDBRouter {
    static let shared = ImageManager() // FIXME: Avoid singleton
    
    private let router = ImageRouter()
    var modelContext: ModelContext?
    
    /// Fetches the image at the path from the cached items, downloading as needed
    ///
    /// In cases where the full-sized image is not found, the completion handler is called twice: once for thumbnail and once for full photo
    func getImage(at path: String, completion: (UIImage) -> Void) async throws {
        let fetchDescriptor = FetchDescriptor<ImageCacheItem>(predicate: #Predicate { $0.path == path})
        let image = try modelContext?.fetch(fetchDescriptor).first // Should be only one present
        
        if let image {
            // Try the large photo first
            if let fullData = image.fullData,
               let uiImage = UIImage(data: fullData) {
                completion(uiImage)
            } else if let thumbData = image.thumbData,
                      let uiImage = UIImage(data: thumbData) {
                completion(uiImage) // Return the thumbnail
                // Update with the larger photo
                try await completion(getRemoteImage(at: path, for: .full))
            }
        } else {
            try await completion(getRemoteImage(at: path, for: .thumbnail)) // Get the thumbnail first
            try await completion(getRemoteImage(at: path, for: .full)) // Update with the larger photo
        }
    }
    
    /// Downloads the image at the specified path, then stores it as an ImageCacheItem
    private func getRemoteImage(at path: String,
                                for size: ImageSize) async throws -> UIImage {
        let (imageData, _) = try await URLSession.shared.data(for: router.urlRequestForImage(at: path, for: size))
        
        guard let uiImage = UIImage(data: imageData)
        else { throw ImageManagerError.InvalidImageData }
        
        try await MainActor.run {
            modelContext?.insert(ImageCacheItem(path: path,
                                                fullData: size == .full ? imageData : nil, // Only keep the larger data
                                                thumbData: size == .thumbnail ? imageData : nil)) // Temporarily keep the thumbnail
            try modelContext?.save()
        }
        
        return uiImage
    }
}

private class ImageRouter: TMDBRouter {
    private let imageURL: String = "https://image.tmdb.org/t/p/"
    
    func urlRequestForImage(at path: String,
                            for size: ImageSize = .full) throws -> URLRequest {
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
