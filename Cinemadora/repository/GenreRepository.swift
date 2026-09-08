//
//  GenreRepository.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 9/7/26.
//

import Foundation

final class GenreRepository {
    
    private let dataSource: DataSource
    private var genres: Dictionary<Int, Genre> = [:]
    private var genresFeeds: Dictionary<Int, GenresFeed> = [:]

    
    init(_ dataSource: DataSource) {
        
        self.dataSource = dataSource
    }
    
    @MainActor
    func genresFeed(for movie: Movie) -> GenresFeed {
        
        if let feed = genresFeeds[movie.id] {
            return feed
        } else {
            let feed = GenresFeed(movie.genreIds, self)
            
            genresFeeds[movie.id] = feed
            return feed
        }
    }

    
    func genre(for id: Int) async throws -> Genre? {

        if genres.isEmpty {
            let r = try await dataSource.fetchGenreList()

            for genre in r.genres {
                genres[genre.id] = genre
            }
        }
        
        return genres[id]
    }
}
