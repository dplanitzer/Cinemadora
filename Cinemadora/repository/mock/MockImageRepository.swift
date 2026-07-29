//
//  MockImageRepository.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/26/26.
//

import UIKit

actor MockImageRepository : ImageRepository {
    
    private var cache: [URL : UIImage] = [:]
    private var activeTasks: [URL : Task<UIImage, Error>] = [:]
    
    
    func image(for basePath: String, usage: ImageUsage, size: ImageSizeClass) async throws -> UIImage {
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w342\(basePath)") else { throw URLError(.cannotFindHost) }
        
        if let image = cache[url] {
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
            cache[url] = image
            activeTasks[url] = nil
            return image
        } catch {
            activeTasks[url] = nil
            throw error
        }
    }
}
