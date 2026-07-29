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
    
    
    init(_ movie: Movie, _ movieRep: MovieRepository) {
        self.movie = movie
        self.movieRep = movieRep
    }
    
    let movie: Movie
}
