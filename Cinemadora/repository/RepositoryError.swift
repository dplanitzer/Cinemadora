//
//  RepositoryError.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/23/26.
//


import Foundation

nonisolated struct RepositoryError : LocalizedError {
    
    let underlyingError: Error
    let url: URL?
    let statusCode: Int?
    
    init(_ error: Error, url: URL? = nil, statusCode: Int? = nil) {
        self.underlyingError = error
        self.url = url
        self.statusCode = statusCode
    }
    
    var errorDescription: String? {
        
        if let url = url, let statusCode = statusCode {
            return "Bad server response: \(statusCode) while accessing URL: \(url)"
        }
        
        if let url = url {
            return "\(underlyingError.localizedDescription) while accessing URL: \(url)"
        }
        
        return underlyingError.localizedDescription
    }
}
