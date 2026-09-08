//
//  MockReviewRepository.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 9/7/26.
//

import Foundation

actor MockReviewRepository : ReviewRepository {
    
    private let dataSource: MockDataSource
    
    
    init(_ dataSource: MockDataSource) {
        
        self.dataSource = dataSource
    }
    
    func fetchReviewsListPage(for movieId: Int, _ pageNum: Int) async throws -> ListPage<Review> {
     
        return try await dataSource.fetch(from: "reviews", type: ListPage<Review>.self)
    }
}
