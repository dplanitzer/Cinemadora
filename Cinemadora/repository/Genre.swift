//
//  Genre.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/29/26.
//

import Foundation


nonisolated struct Genre : Decodable, Identifiable, Equatable, Hashable, Sendable {
    
    let id: Int
    let name: String
}

nonisolated struct GenreList : Decodable, Sendable {
    
    let genres: [Genre]
}
