//
//  GenresFeed.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 9/8/26.
//

import Foundation

@Observable
final class GenresFeed : Feed {
    
    private let repository: GenreRepository
    private let genreIds: [Int]

    
    init(_ genreIds: [Int], _ repository: GenreRepository) {
        
        self.genreIds = genreIds
        self.repository = repository
    }

    private(set) var items: [Genre] = []
    
    private(set) var isLoading = false
    
    private(set) var hasMore = true
    
    func fetchMore() async {
        
        guard !isLoading && hasMore else { return }

        do {
            items = []
            
            for genreId in genreIds {
                if let genre = try await repository.genre(for: genreId) {
                    items.append(genre)
                }
            }
            items.sort { $0.name < $1.name }
        } catch {
        }
        
        isLoading = false
        hasMore = false
    }
}
