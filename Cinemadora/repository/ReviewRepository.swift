//
//  ReviewRepository.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 9/7/26.
//

import Foundation

actor ReviewRepository {
    
    private let dataSource: DataSource

    
    init(_ dataSource: DataSource) {
        
        self.dataSource = dataSource
    }

    @MainActor
    func reviewsFeed(for movieId: Int) -> ReviewsFeed {
        return ReviewsFeed(movieId, self)
    }
    
    func fetchReviewsListPage(for movieId: Int, _ pageNum: Int) async throws -> ListPage<Review> {

        return try await dataSource.fetchReviewsListPage(for: movieId, pageNum)
    }
}
