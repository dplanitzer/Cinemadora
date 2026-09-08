//
//  MockRepository.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/22/26.
//

import Foundation

actor MockMovieRepository : MovieRepository {
    
    private let dataSource: MockDataSource
    
    
    init(_ dataSource: MockDataSource) {
        
        self.dataSource = dataSource
    }
    
    func fetchMovieListPage(for list: ListName, _ pageNum: Int) async throws -> ListPage<Movie> {
        
        return try await dataSource.fetch(from: "popular_movies", type: ListPage<Movie>.self)
    }

    func fetchMovieDetails(for movieId: Int) async throws -> MovieDetails {

        return try await dataSource.fetch(from: "star_wars_movie_details", type: MovieDetails.self)
    }
    
    func fetchSimilarMoviesListPage(for movieId: Int, _ pageNum: Int) async throws -> ListPage<Movie> {
        
        return try await dataSource.fetch(from: "popular_movies", type: ListPage<Movie>.self)
    }
}
