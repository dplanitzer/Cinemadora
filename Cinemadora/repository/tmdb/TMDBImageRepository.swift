//
//  TMDBImageRepository.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/26/26.
//

import UIKit

final class TMDBImageRepository : ImageRepository {
    
    private let dataSource: TMDBDataSource
    private let imageCache: LRUCache<CacheKey, UIImage> = LRUCache()
    private let configurationCache: ConfigurationCache
    
    
    init(_ dataSource: TMDBDataSource) {
        self.dataSource = dataSource
        self.configurationCache = ConfigurationCache(dataSource)
    }
    
    nonisolated func image(for basePath: String, usage: ImageUsage, size: ImageSizeClass) async throws -> UIImage {
        
        let key = CacheKey(basePath, usage, size)
        
        if let image = await imageCache.image(for: key) {
            return image
        }

        
        let (data, response) = try await configurationCache.withConfiguration { config in
            let url = try self.imageUrl(for: basePath, usage: usage, size: size, configuration: config)
            
            return try await URLSession.shared.data(from: url)
        }
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        guard let image = UIImage(data: data) else {
            throw URLError(.cannotDecodeContentData)
        }
        
        await imageCache.insert(image, for: key)
        return image
    }
    
    private nonisolated func imageUrl(for basePath: String, usage: ImageUsage, size: ImageSizeClass, configuration config: TMDBConfiguration) throws -> URL {
        
        let usageSizes: [String]
        let sizeClassIndex: Int
        
        switch usage {
        case .backdrop:
            usageSizes = config.images.backdropSizes
            
        case .poster:
            usageSizes = config.images.posterSizes
            
        case .logo:
            usageSizes = config.images.logoSizes
            
        case .profile:
            usageSizes = config.images.profileSizes
            
        case .still:
            usageSizes = config.images.stillSizes
        }
        
        guard usageSizes.count > 0 else { throw URLError(.badURL) }
        
        switch size {
        case .small:
            sizeClassIndex = 0
            
        case .middle:
            sizeClassIndex = max(usageSizes.count - 2, 0) / 2
            
        case .large:
            sizeClassIndex = max(usageSizes.count - 2, 0)
            
        case .original:
            sizeClassIndex = max(usageSizes.count - 1, 0)
        }
        
        if let url = URL(string: "\(config.images.secureBaseUrl)\(usageSizes[sizeClassIndex])\(basePath)") {
            return url
        } else {
            throw URLError(.badURL)
        }
    }
    
    
    private nonisolated struct CacheKey : Hashable {
        let basePath: String
        let usage: ImageUsage
        let size: ImageSizeClass
        
        init(_ basePath: String, _ usage: ImageUsage, _ size: ImageSizeClass) {
            self.basePath = basePath
            self.usage = usage
            self.size = size
        }
    }


    private actor ConfigurationCache {
        
        private let dataSource: TMDBDataSource
        private var cachedConfiguration: TMDBConfiguration?
        
        
        init(_ dataSource: TMDBDataSource) {
            self.dataSource = dataSource
        }
        
        func withConfiguration<T>(_ closure: (_ configuration: TMDBConfiguration) async throws -> T) async throws -> T {
            
            if cachedConfiguration == nil {
                cachedConfiguration = try await dataSource.fetch(from: "https://api.themoviedb.org/3/configuration", type: TMDBConfiguration.self)
            }
            
            return try await closure(cachedConfiguration!)
        }
    }
}
