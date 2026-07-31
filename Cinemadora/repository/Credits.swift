//
//  Credits.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/30/26.
//

import Foundation

nonisolated struct Credits : Decodable, Identifiable, Equatable, Hashable {
    
    let id: Int
    let cast: [CastMember]
    let crew: [CrewMember]
}

nonisolated struct CastMember : Decodable, Identifiable, Equatable, Hashable {
    
    let adult: Bool?
    let gender: Int?
    let id: Int
    let knownForDepartment: String?
    let name: String
    let originalName: String?
    let popularity: Double?
    let profilePath: String?
    let castId: Int?
    let character: String
    let creditId: String
    let order: Int?
    
    enum CodingKeys : String, CodingKey {
        case adult
        case gender
        case id
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case castId = "cast_id"
        case character
        case creditId = "credit_id"
        case order
    }
}

nonisolated struct CrewMember : Decodable, Identifiable, Equatable, Hashable {
    
    let adult: Bool?
    let gender: Int?
    let id: Int
    let knownForDepartment: String?
    let name: String
    let originalName: String?
    let popularity: Double?
    let profilePath: String?
    let creditId: String
    let department: String
    let job: String
    
    enum CodingKeys : String, CodingKey {
        case adult
        case gender
        case id
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case creditId = "credit_id"
        case department
        case job
    }
}
