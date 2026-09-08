//
//  CompanyRepository.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 9/7/26.
//

import Foundation

actor CompanyRepository {
    
    private let dataSource: DataSource

    
    init(_ dataSource: DataSource) {
        
        self.dataSource = dataSource
    }
    
    func fetchCompanyDetails(for companyId: Int) async throws -> CompanyDetails {
        
        return try await dataSource.fetchCompanyDetails(for: companyId)
    }
}
