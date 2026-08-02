//
//  ReviewsViewModel.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 8/1/26.
//

import Foundation

@Observable
final class ReviewsViewModel {
    
    private let movieRep: MovieRepository
    private let imageRep: ImageRepository
    private let movieId: Int
    
    private var nextPage = 0
    private var pageCount = 1

    
    init(_ movieId: Int, _ movieRep: MovieRepository, _ imageRep: ImageRepository) {
        self.movieId = movieId
        self.movieRep = movieRep
        self.imageRep = imageRep
    }

    private(set) var errorDescription = ""

    private(set) var reviews: [Review] = []
    
    func review(for id: String) -> Review? {
        
        for r in reviews {
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
    
    // Fetches the next page from reviews list. Does nothing if no more data exists.
    func fetchMore() async {
        
        guard !isLoading && hasMore else { return }
        
        isLoading = true
        errorDescription = ""
        
        do {
            let r = try await movieRep.fetchReviewsListPage(for: movieId, nextPage)
            
            reviews.append(contentsOf: r.results)
            pageCount = r.totalPageCount
            nextPage += 1
            
        } catch {
            errorDescription = error.localizedDescription
        }
        
        isLoading = false
    }
}
