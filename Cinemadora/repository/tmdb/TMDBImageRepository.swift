//
//  TMDBImageRepository.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/26/26.
//

import UIKit

actor TMDBImageRepository : ImageRepository {
    
    private let service: TMDBService
    private var cachedConfiguration: TMDBConfiguration? = nil
    private let cache: ImageCache = ImageCache()
    private var activeTasks: [URL : Task<UIImage, Error>] = [:]
    
    
    init(_ service: TMDBService) {
        self.service = service
    }
    
    func image(for basePath: String, usage: ImageUsage, size: ImageSizeClass) async throws -> UIImage {
        
        guard let url = await imageUrl(for: basePath, usage: usage, size: size) else { throw URLError(.cannotConnectToHost) }
        
        if let image = cache.image(for: url) {
            return image
        }
        if let existingTask = activeTasks[url] {
            return try await existingTask.value
        }
        
        
        let task = Task<UIImage, Error> {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let image = UIImage(data: data) {
                return image
            } else {
                throw URLError(.cannotDecodeContentData)
            }
        }
        
        
        activeTasks[url] = task
      
        do {
            let image = try await task.value
            cache.insert(image, for: url)
            activeTasks[url] = nil
            return image
        } catch {
            activeTasks[url] = nil
            throw error
        }
    }

    private func imageUrl(for basePath: String, usage: ImageUsage, size: ImageSizeClass) async -> URL? {
        
        guard let config = await ensureConfiguration() else { return nil }
        let usageSizes: [String]
        let sizeClassIndex: Int
        
        switch usage {
        case .backdrop:
            usageSizes = config.images.backdropSizes
            
        case .poster:
            usageSizes = config.images.posterSizes
            
        case .logo:
            usageSizes = config.images.logoSizes
        }
        
        guard usageSizes.count > 0 else { return nil }
        
        switch size {
        case .small:
            sizeClassIndex = min(1, usageSizes.count - 1)
            
        case .middle:
            sizeClassIndex = usageSizes.count / 2
            
        case .large:
            sizeClassIndex = max(usageSizes.count - 2, 0)
            
        case .original:
            sizeClassIndex = max(usageSizes.count - 1, 0)
        }
        
        return URL(string: "\(config.images.secureBaseUrl)\(usageSizes[sizeClassIndex])\(basePath)")
    }
    
    private func ensureConfiguration() async -> TMDBConfiguration? {
        
        if cachedConfiguration == nil {
            cachedConfiguration = try? await service.fetch(from: "https://api.themoviedb.org/3/configuration", type: TMDBConfiguration.self)
        }
        return cachedConfiguration
    }
}


private nonisolated class CacheNode {
    
    let key: URL
    var image: UIImage
    var previous: CacheNode?
    var next: CacheNode?
    
    init(key: URL, image: UIImage) {
        self.key = key
        self.image = image
    }
}


private nonisolated final class ImageCache {
    
    private let capacity: Int
    private var cache: [URL: CacheNode] = [:]
    
    private var newest: CacheNode?
    private var oldest: CacheNode?
    

    init(capacity: Int = 40) {
        self.capacity = capacity
    }
    
    func image(for url: URL) -> UIImage? {
        guard let node = cache[url] else { return nil }
        
        // Move accessed node to the head (most recent)
        moveToHead(node)
        return node.image
    }
    
    func insert(_ image: UIImage, for url: URL) {
        if let existingNode = self.cache[url] {
            // Update existing cache node
            existingNode.image = image
            moveToHead(existingNode)
        } else {
            // Create a new cache node
            let newNode = CacheNode(key: url, image: image)
            cache[url] = newNode
            addToHead(newNode)
                
            // Evict oldest if over capacity
            if cache.count > self.capacity {
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
