//
//  MovieDetailsViewModel.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/23/26.
//

import UIKit

@Observable
class MovieDetailsViewModel {
        
    private let movieRep: MovieRepository
    private let movieId: Int
    
    
    init(_ movieId: Int, _ movieRep: MovieRepository) {
        self.movieId = movieId
        self.movieRep = movieRep
    }
    
    private(set) var details: MovieDetails?
    
    func fetchDetails() async {
        
        guard details == nil else { return }
        
        do {
            details = try await movieRep.fetchMovieDetails(for: movieId)
        } catch {
            print(error.localizedDescription)
        }
    }
}
