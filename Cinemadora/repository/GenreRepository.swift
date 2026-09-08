//
//  GenreRepository.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 9/7/26.
//

import Foundation

protocol GenreRepository {
   
    func genre(for id: Int) async throws -> Genre?
}
