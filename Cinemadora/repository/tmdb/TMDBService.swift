//
//  TMDBService.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/26/26.
//

import Foundation

nonisolated final class TMDBService : Sendable {
    
    private let token: String
    
    init(_ token: String) {
        self.token = token
    }
    
    func fetch<T: Decodable>(from urlString: String, type: T.Type) async throws -> T {
        
        guard let url = URL(string: urlString) else {
            throw RepositoryError(URLError(.badURL))
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: createRequest(url))
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw RepositoryError(URLError(.badServerResponse), url: url)
            }
            
            if httpResponse.statusCode < 200 || httpResponse.statusCode >= 300 {
                throw RepositoryError(URLError(.badServerResponse), url: url, statusCode: httpResponse.statusCode)
            }
            
            
            return try JSONDecoder().decode(type, from: data)
        } catch {
            throw RepositoryError(error, url: url)
        }
    }

    private func createRequest(_ url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "accept")
        
        return request
    }
}
