//
//  MockRepository.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/22/26.
//

import Foundation

actor MockMovieRepository : MovieRepository {
    
    private var genres: Dictionary<Int, String> = [:]
    
    
    func fetchMovieListPage(_ list: ListName, _ pageNum: Int) async throws -> ListPage<Movie> {
        
        return try await fetch(from: "popular_movies", type: ListPage<Movie>.self)
    }

    func movieDetails(for movieId: Int) async throws -> MovieDetails {

        return try await fetch(from: "star_wars_movie_details", type: MovieDetails.self)
    }

    func fetchReviewsListPage(_ movieId: Int, _ pageNum: Int) async throws -> ListPage<Review> {
     
        return try await fetch(from: "reviews", type: ListPage<Review>.self)
    }
    
    func fetchSimilarMoviesListPage(_ movieId: Int, _ pageNum: Int) async throws -> ListPage<Movie> {
        
        return try await fetch(from: "popular_movies", type: ListPage<Movie>.self)
    }
    
    func fetchCredits(_ movieId: Int) async throws -> Credits {
        
        return try await fetch(from: "credits", type: Credits.self)
    }
    
    func genre(for id: Int) async throws -> String? {

        if genres.isEmpty {
            let r = try await fetch(from: "movie_genres", type: GenreList.self)

            for genre in r.genres {
                genres[genre.id] = genre.name
            }
        }
        
        return genres[id]
    }

    private func fetch<T: Decodable>(from fileName: String, type: T.Type) async throws -> T {
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            throw RepositoryError(URLError(.fileDoesNotExist))
        }
        
        try await Task.sleep(nanoseconds: 1_500_000_000)
        return try JSONDecoder().decode(type, from: try Data(contentsOf: url))
    }
}
