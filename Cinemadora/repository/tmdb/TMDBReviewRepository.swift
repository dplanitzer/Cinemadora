//
//  TMDBReviewRepository.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 9/7/26.
//

import Foundation

actor TMDBReviewRepository : ReviewRepository {
    
    private let dataSource: TMDBDataSource

    
    init(_ dataSource: TMDBDataSource) {
        self.dataSource = dataSource
    }
    
    func fetchReviewsListPage(for movieId: Int, _ pageNum: Int) async throws -> ListPage<Review> {

        return try await dataSource.fetch(from: "https://api.themoviedb.org/3/movie/\(movieId)/reviews?language=\(languageRegion)&page=\(pageNum + 1)", type: ListPage<Review>.self)
    }

    private var languageRegion: String {
        return NSLocale.preferredLanguages.first ?? "en-US"
    }
}
