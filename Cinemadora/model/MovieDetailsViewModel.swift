//
//  MovieDetailsViewModel.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/23/26.
//

import UIKit

@Observable
class MovieDetailsViewModel {
        
    private let movieRepository: MovieRepository
    
    
    init(_ movie: Movie, _ movieRep: MovieRepository) {
        self.movie = movie
        self.movieRepository = movieRep
    }
    
    let movie: Movie
}
