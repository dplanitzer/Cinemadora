//
//  MovieViewModel.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/29/26.
//

import Foundation

@Observable
final class MovieViewModel {
    
    private let movieRep: MovieRepository
        
    
    init(_  movie: Movie, _ movieRep: MovieRepository) {
        self.movie = movie
        self.movieRep = movieRep
    }

    let movie: Movie

    var hasFetchedGenres: Bool = false
    
    var genres: [Int : String] = [:]

    func fetchGenres() async {
        
        guard !hasFetchedGenres else { return }
        
        do {
            genres = [:]
            for genreId in movie.genreIds {
                if let genreName = try await movieRep.genre(for: genreId) {
                    genres[genreId] = genreName
                }
            }
        } catch {
        }
        hasFetchedGenres = true
    }
}
