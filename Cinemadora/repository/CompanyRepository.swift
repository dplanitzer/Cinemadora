//
//  CompanyRepository.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 9/7/26.
//

import Foundation

protocol CompanyRepository {
    
    func fetchCompanyDetails(for companyId: Int) async throws -> CompanyDetails
}
