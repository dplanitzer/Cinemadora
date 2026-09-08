//
//  TMDBDataSource.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/26/26.
//

import Foundation

nonisolated final class TMDBDataSource : DataSource {
    
    private let token: String
    
    init(_ token: String) {
        
        self.token = token
    }
    
    func fetchMovieListPage(for list: ListName, _ pageNum: Int) async throws -> ListPage<Movie> {
        
        let listName: String
        
        switch (list) {
        case .popular:  listName = "popular"
        case .upcoming: listName = "upcoming"
        case .topRated: listName = "top_rated"
        }

        return try await fetch(from: "https://api.themoviedb.org/3/movie/\(listName)?language=\(languageRegion)&page=\(pageNum + 1)", type: ListPage<Movie>.self)
    }
    
    func fetchMovieDetails(for movieId: Int) async throws -> MovieDetails {
        
        return try await fetch(from: "https://api.themoviedb.org/3/movie/\(movieId)?language=\(languageRegion)&append_to_response=credits", type: MovieDetails.self)
    }
    
    func fetchSimilarMoviesListPage(for movieId: Int, _ pageNum: Int) async throws -> ListPage<Movie> {

        return try await fetch(from: "https://api.themoviedb.org/3/movie/\(movieId)/similar?language=\(languageRegion)&page=\(pageNum + 1)", type: ListPage<Movie>.self)
    }

    func fetchGenreList() async throws -> GenreList {
        
        return try await fetch(from: "https://api.themoviedb.org/3/genre/movie/list?language=\(languageRegion)", type: GenreList.self)
    }
    
    func fetchReviewsListPage(for movieId: Int, _ pageNum: Int) async throws -> ListPage<Review> {

        return try await fetch(from: "https://api.themoviedb.org/3/movie/\(movieId)/reviews?language=\(languageRegion)&page=\(pageNum + 1)", type: ListPage<Review>.self)
    }
    
    func fetchCompanyDetails(for companyId: Int) async throws -> CompanyDetails {
        
        return try await fetch(from: "https://api.themoviedb.org/3/company/\(companyId)", type: CompanyDetails.self)
    }
    
    func fetchPersonDetails(for personId: Int) async throws -> PersonDetails {
        
        return try await fetch(from: "https://api.themoviedb.org/3/person/\(personId)?language=\(languageRegion)", type: PersonDetails.self)
    }
    
    func fetch<T: Decodable>(from urlString: String, type: T.Type) async throws -> T {
        
        guard let url = URL(string: urlString) else {
            throw RepositoryError(URLError(.badURL))
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: createRequest(url))
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw RepositoryError(URLError(.badServerResponse), url: url)
            }
            
            if httpResponse.statusCode < 200 || httpResponse.statusCode >= 300 {
                throw RepositoryError(URLError(.badServerResponse), url: url, statusCode: httpResponse.statusCode)
            }
            
            
            return try JSONDecoder().decode(type, from: data)
        } catch {
            throw RepositoryError(error, url: url)
        }
    }

    private func createRequest(_ url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "accept")
        
        return request
    }
    
    private var languageRegion: String {
        return NSLocale.preferredLanguages.first ?? "en-US"
    }
}
