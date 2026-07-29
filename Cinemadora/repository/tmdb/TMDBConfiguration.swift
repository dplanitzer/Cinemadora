//
//  TMDBConfiguration.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/26/26.
//

import Foundation

nonisolated struct TMDBConfiguration : Decodable, Equatable, Hashable {
    
    let images: TMDBImages
    let changeKeys: [String]
    
    enum CodingKeys : String, CodingKey {
        case images
        case changeKeys = "change_keys"
    }
}

nonisolated struct TMDBImages : Decodable, Equatable, Hashable {
    
    let baseUrl: String
    let secureBaseUrl: String
    let backdropSizes: [String]
    let logoSizes: [String]
    let posterSizes: [String]
    let profileSizes: [String]
    let stillSizes: [String]
    
    enum CodingKeys : String, CodingKey {
        case baseUrl = "base_url"
        case secureBaseUrl = "secure_base_url"
        case backdropSizes = "backdrop_sizes"
        case logoSizes = "logo_sizes"
        case posterSizes = "poster_sizes"
        case profileSizes = "profile_sizes"
        case stillSizes = "still_sizes"
    }
}
