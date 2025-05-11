//
//  ImageCacheItem.swift
//  TMDB-2Coders
//
//  Created by Gjorgji Zhupan on 11.5.25.
//

import Foundation
import SwiftData

@Model
final class ImageCacheItem {
    @Attribute(.unique) var path: String
    var fullData: Data?
    var thumbData: Data?
    
    // MARK: - init
    init(path: String, fullData: Data?, thumbData: Data?) {
        self.path = path
        self.fullData = fullData
        self.thumbData = thumbData
    }
}
