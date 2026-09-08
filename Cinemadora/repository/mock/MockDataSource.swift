//
//  MockDataSource.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 9/7/26.
//

import Foundation

nonisolated final class MockDataSource : DataSource {

    func fetchMovieListPage(for list: ListName, _ pageNum: Int) async throws -> ListPage<Movie> {
        
        return try await fetch(from: "popular_movies", type: ListPage<Movie>.self)
    }
    
    func fetchMovieDetails(for movieId: Int) async throws -> MovieDetails {

        return try await fetch(from: "star_wars_movie_details", type: MovieDetails.self)
    }
    
    func fetchSimilarMoviesListPage(for movieId: Int, _ pageNum: Int) async throws -> ListPage<Movie> {
        
        return try await fetch(from: "popular_movies", type: ListPage<Movie>.self)
    }

    func fetchGenreList() async throws -> GenreList {
        
        return try await fetch(from: "movie_genres", type: GenreList.self)
    }
    
    func fetchReviewsListPage(for movieId: Int, _ pageNum: Int) async throws -> ListPage<Review> {
     
        return try await fetch(from: "reviews", type: ListPage<Review>.self)
    }
    
    func fetchCompanyDetails(for companyId: Int) async throws -> CompanyDetails {

        return try await fetch(from: "lucasfilm", type: CompanyDetails.self)
    }
    
    func fetchPersonDetails(for personId: Int) async throws -> PersonDetails {

        return try await fetch(from: "tom_hanks", type: PersonDetails.self)
    }

    func fetch<T: Decodable>(from fileName: String, type: T.Type) async throws -> T {
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            throw RepositoryError(URLError(.fileDoesNotExist))
        }
        
        try await Task.sleep(nanoseconds: 1_500_000_000)
        return try JSONDecoder().decode(type, from: try Data(contentsOf: url))
    }
}
