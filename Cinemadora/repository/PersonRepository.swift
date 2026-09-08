//
//  PersonRepository.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 9/7/26.
//

import Foundation

actor PersonRepository {
    
    private let dataSource: DataSource
    
    
    init(_ dataSource: DataSource) {
        
        self.dataSource = dataSource
    }
    
    func fetchPersonDetails(for personId: Int) async throws -> PersonDetails {

        return try await dataSource.fetchPersonDetails(for: personId)
    }
}
