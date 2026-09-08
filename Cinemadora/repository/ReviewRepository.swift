//
//  ReviewRepository.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 9/7/26.
//

import Foundation

protocol ReviewRepository {
    
    func fetchReviewsListPage(for movieId: Int, _ pageNum: Int) async throws -> ListPage<Review>
}


extension ReviewRepository {
    
    func reviewsFeed(for movieId: Int) -> ReviewsFeed {
        return ReviewsFeed(movieId, self)
    }
}
