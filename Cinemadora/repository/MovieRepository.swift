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

actor MovieRepository {
    
    private let dataSource: DataSource

    
    init(_ dataSource: DataSource) {
        
        self.dataSource = dataSource
    }
    
    func fetchMovieListPage(for list: ListName, _ pageNum: Int) async throws -> ListPage<Movie> {
        
        return try await dataSource.fetchMovieListPage(for: list, pageNum)
    }
    
    func fetchMovieDetails(for movieId: Int) async throws -> MovieDetails {
        
        return try await dataSource.fetchMovieDetails(for: movieId)
    }
    
    func fetchSimilarMoviesListPage(for movieId: Int, _ pageNum: Int) async throws -> ListPage<Movie> {

        return try await dataSource.fetchSimilarMoviesListPage(for: movieId, pageNum)
    }
}
