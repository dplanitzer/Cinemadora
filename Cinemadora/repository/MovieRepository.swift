//
//  MovieRepository.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/22/26.
//

import Foundation

enum ListName {
    case popular
    case upcoming
    case topRated
}

protocol MovieRepository {
    
    func fetchListPage(_ list: ListName, _ pageNum: Int) async throws -> ListPage<Movie>
    
    func movieDetails(for id: Int) async throws -> MovieDetails
    
    func genre(for id: Int) async throws -> String?
}
