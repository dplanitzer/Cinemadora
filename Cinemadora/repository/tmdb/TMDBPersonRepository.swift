//
//  TMDBPersonRepository.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 9/7/26.
//

import Foundation

actor TMDBPersonRepository : PersonRepository {
    
    private let dataSource: TMDBDataSource

    
    init(_ dataSource: TMDBDataSource) {
        self.dataSource = dataSource
    }
    
    func fetchPersonDetails(for personId: Int) async throws -> PersonDetails {
        
        return try await dataSource.fetch(from: "https://api.themoviedb.org/3/person/\(personId)?language=\(languageRegion)", type: PersonDetails.self)
    }

    private var languageRegion: String {
        return NSLocale.preferredLanguages.first ?? "en-US"
    }
}
