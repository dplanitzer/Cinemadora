//
//  CompanyDetails.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 8/8/26.
//

import Foundation

nonisolated struct CompanyDetails : Decodable, Identifiable, Equatable, Hashable {
    
    let description: String
    let headquarters: String?
    let homepage: String?
    let id: Int
    let logoPath: String?
    let name: String
    let originCountry: String?
    let parentCompany: String?
    
    enum CodingKeys : String, CodingKey {
        case description
        case headquarters
        case homepage
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
        case parentCompany = "parent_company"
    }
}
