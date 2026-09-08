//
//  LRUCache.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 9/6/26.
//

import Foundation

actor LRUCache<Key, Value> where Key: Hashable {
    
    private nonisolated final class CacheNode {
        
        let key: Key
        var value: Value
        var previous: CacheNode?
        var next: CacheNode?
        
        init(_ key: Key, _ value: Value) {
            self.key = key
            self.value = value
        }
    }

    
    private let capacity: Int
    private var cache: [Key: CacheNode] = [:]
    
    private var newest: CacheNode?
    private var oldest: CacheNode?
    

    init(capacity: Int = 40) {
        self.capacity = capacity
    }
    
    func value(for key: Key) -> Value? {
        guard let node = cache[key] else { return nil }
        
        // Move accessed node to the head (most recent)
        moveToHead(node)
        return node.value
    }
    
    func insert(_ value: Value, for key: Key) {
        if let existingNode = cache[key] {
            // Update existing cache node
            existingNode.value = value
            moveToHead(existingNode)
        } else {
            // Create a new cache node
            let newNode = CacheNode(key, value)
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
