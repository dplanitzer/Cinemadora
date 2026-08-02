//
//  Review.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/30/26.
//

import Foundation

import Foundation

nonisolated struct Review : Decodable, Identifiable, Equatable, Hashable {

    let author: String
    let authorDetails: AuthorDetails
    let content: String
    let createdAt: String
    let id: String
    let updatedAt: String?
    let url: String?
    
    enum CodingKeys : String, CodingKey {
        case author
        case authorDetails = "author_details"
        case content
        case createdAt = "created_at"
        case id
        case updatedAt = "updated_at"
        case url
    }
}

nonisolated struct AuthorDetails : Decodable, Equatable, Hashable {

    let name: String
    let userName: String
    let avatarPath: String?
    let rating: Double?
    
    enum CodingKeys : String, CodingKey {
        case name
        case userName = "username"
        case avatarPath = "avatar_path"
        case rating
    }
}
