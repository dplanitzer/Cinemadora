//
//  MovieListResponse.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/22/26.
//

import Foundation

nonisolated struct MovieListResponse<Element: Decodable> : Decodable {
    
    let page: Int
    let results: [Element]
    let totalPageCount: Int
    let totalResultCount: Int
    
    enum CodingKeys : String, CodingKey {
        case page
        case results
        case totalPageCount = "total_pages"
        case totalResultCount = "total_results"
    }
}
