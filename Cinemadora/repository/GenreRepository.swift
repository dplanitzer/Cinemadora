//
//  GenreRepository.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 9/7/26.
//

import Foundation

actor GenreRepository {
    
    private let dataSource: DataSource
    private var genres: Dictionary<Int, Genre> = [:]

    
    init(_ dataSource: DataSource) {
        
        self.dataSource = dataSource
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
