//
//  TMDBImageRepository.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/26/26.
//

import UIKit

final class TMDBImageRepository : ImageRepository {
    
    private let service: TMDBService
    private let imageCache: ImageCache = ImageCache()
    private let configurationCache: ConfigurationCache
    
    
    init(_ service: TMDBService) {
        self.service = service
        self.configurationCache = ConfigurationCache(service)
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
            sizeClassIndex = max(usageSizes.count - 1, 0) / 2
            
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


private nonisolated final class CacheNode {
    
    let key: CacheKey
    var image: UIImage
    var previous: CacheNode?
    var next: CacheNode?
    
    init(_ key: CacheKey, _ image: UIImage) {
        self.key = key
        self.image = image
    }
}


private actor ImageCache {
    
    private let capacity: Int
    private var cache: [CacheKey: CacheNode] = [:]
    
    private var newest: CacheNode?
    private var oldest: CacheNode?
    

    init(capacity: Int = 40) {
        self.capacity = capacity
    }
    
    func image(for key: CacheKey) -> UIImage? {
        guard let node = cache[key] else { return nil }
        
        // Move accessed node to the head (most recent)
        moveToHead(node)
        return node.image
    }
    
    func insert(_ image: UIImage, for key: CacheKey) {
        if let existingNode = cache[key] {
            // Update existing cache node
            existingNode.image = image
            moveToHead(existingNode)
        } else {
            // Create a new cache node
            let newNode = CacheNode(key, image)
            cache[key] = newNode
            addToHead(newNode)
                
            // Evict oldest if over capacity
            if cache.count > capacity {
                evictOldest()
            }
        }
    }
    

    private func addToHead(_ node: CacheNode) {
        node.next = newest
        node.previous = nil
        
        if let currentHead = newest {
            currentHead.previous = node
        }
        newest = node
        
        if oldest == nil {
            oldest = node
        }
    }
    
    private func removeNode(_ node: CacheNode) {
        if let prev = node.previous {
            prev.next = node.next
        } else {
            newest = node.next
        }
        
        if let next = node.next {
            next.previous = node.previous
        } else {
            oldest = node.previous
        }
    }
    
    private func moveToHead(_ node: CacheNode) {
        removeNode(node)
        addToHead(node)
    }
    
    private func evictOldest() {
        guard let oldestNode = oldest else { return }
        
        removeNode(oldestNode)
        cache.removeValue(forKey: oldestNode.key)
    }
}


private actor ConfigurationCache {
    
    private let service: TMDBService
    private var cachedConfiguration: TMDBConfiguration?
    
    
    init(_ service: TMDBService) {
        self.service = service
    }
    
    func withConfiguration<T>(_ closure: (_ configuration: TMDBConfiguration) async throws -> T) async throws -> T {
        
        if cachedConfiguration == nil {
            cachedConfiguration = try await service.fetch(from: "https://api.themoviedb.org/3/configuration", type: TMDBConfiguration.self)
        }
        
        return try await closure(cachedConfiguration!)
    }
}
