//
//  MockRepository.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/22/26.
//

import Foundation

actor MockMovieRepository : MovieRepository {
    
    private var genres: Dictionary<Int, String> = [:]
    
    
    func fetchListPage(_ list: ListName, _ pageNum: Int) async throws -> ListPage {
        
        let r = try await fetch(from: "popular_movies", type: MovieListPage<Movie>.self)

        return ListPage(movies: r.results, pageCount: r.totalPageCount)
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
