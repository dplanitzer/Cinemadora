//
//  ReviewsFeed.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 9/3/26.
//

import Foundation

@Observable
final class ReviewsFeed : Feed {
    
    private let repository: ReviewRepository
    private let movieId: Int
    
    private var nextPage = 0
    private var pageCount = 1

    
    init(_ movieId: Int, _ repository: ReviewRepository) {
        
        self.movieId = movieId
        self.repository = repository
    }

    private(set) var errorDescription = ""

    private(set) var items: [Review] = []
    
    func review(for id: String) -> Review? {
        
        for r in items {
            if r.id == id {
                return r
            }
        }
        return nil
    }
    
    private(set) var isLoading = false
    
    var hasMore: Bool {
        return nextPage < pageCount
    }
    
    // Fetches the next page from the reviews list. Does nothing if no more data exists.
    func fetchMore() async {
        
        guard !isLoading && hasMore else { return }
        
        isLoading = true
        errorDescription = ""
            
        do {
            let r = try await repository.fetchReviewsListPage(for: movieId, nextPage)
                
            items.append(contentsOf: r.results)
            pageCount = r.totalPageCount
            nextPage += 1
                
        } catch {
            errorDescription = error.localizedDescription
        }
            
        isLoading = false
    }
}
