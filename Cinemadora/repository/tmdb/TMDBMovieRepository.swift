//
//  TMDBRepository.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/22/26.
//

import Foundation

actor TMDBMovieRepository : MovieRepository {
    
    private let dataSource: TMDBDataSource

    
    init(_ dataSource: TMDBDataSource) {
        self.dataSource = dataSource
    }
    
    func fetchMovieListPage(for list: ListName, _ pageNum: Int) async throws -> ListPage<Movie> {
        
        let listName: String
        
        switch (list) {
        case .popular:  listName = "popular"
        case .upcoming: listName = "upcoming"
        case .topRated: listName = "top_rated"
        }

        return try await dataSource.fetch(from: "https://api.themoviedb.org/3/movie/\(listName)?language=\(languageRegion)&page=\(pageNum + 1)", type: ListPage<Movie>.self)
    }
    
    func fetchMovieDetails(for movieId: Int) async throws -> MovieDetails {
        
        return try await dataSource.fetch(from: "https://api.themoviedb.org/3/movie/\(movieId)?language=\(languageRegion)&append_to_response=credits", type: MovieDetails.self)
    }
    
    func fetchSimilarMoviesListPage(for movieId: Int, _ pageNum: Int) async throws -> ListPage<Movie> {

        return try await dataSource.fetch(from: "https://api.themoviedb.org/3/movie/\(movieId)/similar?language=\(languageRegion)&page=\(pageNum + 1)", type: ListPage<Movie>.self)
    }

    private var languageRegion: String {
        return NSLocale.preferredLanguages.first ?? "en-US"
    }
}
