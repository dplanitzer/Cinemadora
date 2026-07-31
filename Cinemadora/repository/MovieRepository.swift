//
//  MovieRepository.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/22/26.
//

import Foundation

enum ListName {
    case popular
    case upcoming
    case topRated
}

protocol MovieRepository {
    
    func fetchMovieListPage(_ list: ListName, _ pageNum: Int) async throws -> ListPage<Movie>
    
    func movieDetails(for movieId: Int) async throws -> MovieDetails
    
    func fetchReviewsListPage(_ movieId: Int, _ pageNum: Int) async throws -> ListPage<Review>

    func genre(for id: Int) async throws -> String?
}
