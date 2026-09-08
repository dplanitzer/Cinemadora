//
//  PersonRepository.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 9/7/26.
//

import Foundation

protocol PersonRepository {
    
    func fetchPersonDetails(for personId: Int) async throws -> PersonDetails
}
