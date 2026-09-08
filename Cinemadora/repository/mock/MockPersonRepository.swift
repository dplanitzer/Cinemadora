//
//  MockPersonRepository.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 9/7/26.
//

import Foundation

actor MockPersonRepository : PersonRepository {
    
    private let dataSource: MockDataSource
    
    
    init(_ dataSource: MockDataSource) {
        
        self.dataSource = dataSource
    }
    
    func fetchPersonDetails(for personId: Int) async throws -> PersonDetails {

        return try await dataSource.fetch(from: "tom_hanks", type: PersonDetails.self)
    }
}
