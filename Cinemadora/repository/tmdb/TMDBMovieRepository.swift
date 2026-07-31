//
//  TMDBRepository.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/22/26.
//

import Foundation

actor TMDBMovieRepository : MovieRepository {
    
    private let service: TMDBService
    private var genres: Dictionary<Int, String> = [:]

    
    init(_ service: TMDBService) {
        self.service = service
    }
    
    func fetchMovieListPage(_ list: ListName, _ pageNum: Int) async throws -> ListPage<Movie> {
        
        let langReg = NSLocale.preferredLanguages.first ?? "en-US"
        let listName: String
        
        switch (list) {
        case .popular:  listName = "popular"
        case .upcoming: listName = "upcoming"
        case .topRated: listName = "top_rated"
        }

        return try await service.fetch(from: "https://api.themoviedb.org/3/movie/\(listName)?language=\(langReg)&page=\(pageNum + 1)", type: ListPage<Movie>.self)
    }
    
    func movieDetails(for movieId: Int) async throws -> MovieDetails {
        
        return try await service.fetch(from: "https://api.themoviedb.org/3/movie/\(movieId)", type: MovieDetails.self)
    }
    
    func fetchReviewsListPage(_ movieId: Int, _ pageNum: Int) async throws -> ListPage<Review> {

        let langReg = NSLocale.preferredLanguages.first ?? "en-US"

        return try await service.fetch(from: "https://api.themoviedb.org/3/movie/\(movieId)/reviews?language=\(langReg)&page=\(pageNum + 1)", type: ListPage<Review>.self)
    }
    
    func genre(for id: Int) async throws -> String? {

        if genres.isEmpty {
            let r = try await service.fetch(from: "https://api.themoviedb.org/3/genre/movie/list", type: GenreList.self)

            for genre in r.genres {
                genres[genre.id] = genre.name
            }
        }
        
        return genres[id]
    }
}
