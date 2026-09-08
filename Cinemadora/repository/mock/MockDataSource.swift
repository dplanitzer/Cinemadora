//
//  MockDataSource.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 9/7/26.
//

import Foundation

nonisolated final class MockDataSource : Sendable {

    func fetch<T: Decodable>(from fileName: String, type: T.Type) async throws -> T {
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            throw RepositoryError(URLError(.fileDoesNotExist))
        }
        
        try await Task.sleep(nanoseconds: 1_500_000_000)
        return try JSONDecoder().decode(type, from: try Data(contentsOf: url))
    }
}
