//
//  TMDBCompanyRepository.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 9/7/26.
//

import Foundation

actor TMDBCompanyRepository : CompanyRepository {
    
    private let dataSource: TMDBDataSource

    
    init(_ dataSource: TMDBDataSource) {
        self.dataSource = dataSource
    }
    
    func fetchCompanyDetails(for companyId: Int) async throws -> CompanyDetails {
        
        return try await dataSource.fetch(from: "https://api.themoviedb.org/3/company/\(companyId)", type: CompanyDetails.self)
    }

    private var languageRegion: String {
        return NSLocale.preferredLanguages.first ?? "en-US"
    }
}
