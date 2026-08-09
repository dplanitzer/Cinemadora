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
    
    func fetchMovieListPage(for list: ListName, _ pageNum: Int) async throws -> ListPage<Movie> {
        
        let listName: String
        
        switch (list) {
        case .popular:  listName = "popular"
        case .upcoming: listName = "upcoming"
        case .topRated: listName = "top_rated"
        }

        return try await service.fetch(from: "https://api.themoviedb.org/3/movie/\(listName)?language=\(languageRegion)&page=\(pageNum + 1)", type: ListPage<Movie>.self)
    }
    
    func fetchMovieDetails(for movieId: Int) async throws -> MovieDetails {
        
        return try await service.fetch(from: "https://api.themoviedb.org/3/movie/\(movieId)?language=\(languageRegion)", type: MovieDetails.self)
    }
    
    func fetchReviewsListPage(for movieId: Int, _ pageNum: Int) async throws -> ListPage<Review> {

        return try await service.fetch(from: "https://api.themoviedb.org/3/movie/\(movieId)/reviews?language=\(languageRegion)&page=\(pageNum + 1)", type: ListPage<Review>.self)
    }
    
    func fetchSimilarMoviesListPage(for movieId: Int, _ pageNum: Int) async throws -> ListPage<Movie> {

        return try await service.fetch(from: "https://api.themoviedb.org/3/movie/\(movieId)/similar?language=\(languageRegion)&page=\(pageNum + 1)", type: ListPage<Movie>.self)
    }
    
    func fetchCredits(for movieId: Int) async throws -> Credits {
        
        return try await service.fetch(from: "https://api.themoviedb.org/3/movie/\(movieId)/credits?language=\(languageRegion)", type: Credits.self)
    }

    func fetchPersonDetails(for personId: Int) async throws -> PersonDetails {
        
        return try await service.fetch(from: "https://api.themoviedb.org/3/person/\(personId)?language=\(languageRegion)", type: PersonDetails.self)
    }

    func fetchCompanyDetails(for companyId: Int) async throws -> CompanyDetails {
        
        return try await service.fetch(from: "https://api.themoviedb.org/3/company/\(companyId)", type: CompanyDetails.self)
    }

    func genre(for id: Int) async throws -> String? {

        if genres.isEmpty {
            let r = try await service.fetch(from: "https://api.themoviedb.org/3/genre/movie/list?language=\(languageRegion)", type: GenreList.self)

            for genre in r.genres {
                genres[genre.id] = genre.name
            }
        }
        
        return genres[id]
    }
    
    private var languageRegion: String {
        return NSLocale.preferredLanguages.first ?? "en-US"
    }
}
