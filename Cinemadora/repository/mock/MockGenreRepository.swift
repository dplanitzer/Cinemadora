//
//  MockGenreRepository.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 9/7/26.
//

import Foundation

actor MockGenreRepository : GenreRepository {
    
    private let dataSource: MockDataSource
    private var genres: Dictionary<Int, Genre> = [:]
    
    init(_ dataSource: MockDataSource) {
        
        self.dataSource = dataSource
    }
    
    func genre(for id: Int) async throws -> Genre? {

        if genres.isEmpty {
            let r = try await dataSource.fetch(from: "movie_genres", type: GenreList.self)

            for genre in r.genres {
                genres[genre.id] = genre
            }
        }
        
        return genres[id]
    }
}
