//
//  MockCompanyRepository.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 9/7/26.
//

import Foundation

actor MockCompanyRepository : CompanyRepository {
    
    private let dataSource: MockDataSource
    
    
    init(_ dataSource: MockDataSource) {
        
        self.dataSource = dataSource
    }
    
    func fetchCompanyDetails(for companyId: Int) async throws -> CompanyDetails {

        return try await dataSource.fetch(from: "lucasfilm", type: CompanyDetails.self)
    }
}
