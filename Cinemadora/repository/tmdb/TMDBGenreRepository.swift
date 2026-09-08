//
//  TMDBGenreRepository.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 9/7/26.
//

import Foundation

actor TMDBGenreRepository : GenreRepository {
    
    private let dataSource: TMDBDataSource
    private var genres: Dictionary<Int, Genre> = [:]

    
    init(_ dataSource: TMDBDataSource) {
        self.dataSource = dataSource
    }
    
    func genre(for id: Int) async throws -> Genre? {

        if genres.isEmpty {
            let r = try await dataSource.fetch(from: "https://api.themoviedb.org/3/genre/movie/list?language=\(languageRegion)", type: GenreList.self)

            for genre in r.genres {
                genres[genre.id] = genre
            }
        }
        
        return genres[id]
    }
    
    private var languageRegion: String {
        return NSLocale.preferredLanguages.first ?? "en-US"
    }
}
