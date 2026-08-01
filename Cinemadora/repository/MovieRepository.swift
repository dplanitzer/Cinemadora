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
    
    func fetchMovieListPage(for list: ListName, _ pageNum: Int) async throws -> ListPage<Movie>
    
    func fetchMovieDetails(for movieId: Int) async throws -> MovieDetails
    
    func fetchReviewsListPage(for movieId: Int, _ pageNum: Int) async throws -> ListPage<Review>

    func fetchSimilarMoviesListPage(for movieId: Int, _ pageNum: Int) async throws -> ListPage<Movie>

    func fetchCredits(for movieId: Int) async throws -> Credits
    
    func genre(for id: Int) async throws -> String?
}
