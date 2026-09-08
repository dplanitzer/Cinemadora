//
//  DataSource.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 9/7/26.
//

import Foundation

protocol DataSource: Sendable {
    
    func fetchMovieListPage(for list: ListName, _ pageNum: Int) async throws -> ListPage<Movie>
    
    func fetchMovieDetails(for movieId: Int) async throws -> MovieDetails
    
    func fetchSimilarMoviesListPage(for movieId: Int, _ pageNum: Int) async throws -> ListPage<Movie>

    func fetchGenreList() async throws -> GenreList
    
    func fetchReviewsListPage(for movieId: Int, _ pageNum: Int) async throws -> ListPage<Review>
    
    func fetchCompanyDetails(for companyId: Int) async throws -> CompanyDetails
    
    func fetchPersonDetails(for personId: Int) async throws -> PersonDetails
}
