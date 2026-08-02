//
//  MovieViewModel.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/29/26.
//

import Foundation

@Observable
final class MovieViewModel : Identifiable {
    
    private let movieRep: MovieRepository
    private let imageRep: ImageRepository
        
    
    init(_  movie: Movie, _ movieRep: MovieRepository, _ imageRep: ImageRepository) {
        self.movie = movie
        self.movieRep = movieRep
        self.imageRep = imageRep
        self.posterImage = ImageLocator(imageRep, movie.posterPath, .poster)
    }

    var id: Int {
        return movie.id
    }

    let movie: Movie
    
    let posterImage: ImageLocator

    
    private(set) var hasFetchedGenres: Bool = false
    
    // Loaded genres, sorted by name
    private(set) var genres: [String] = []

    func fetchGenres() async {
        
        guard !hasFetchedGenres else { return }
        
        do {
            genres = []
            for genreId in movie.genreIds {
                if let genreName = try await movieRep.genre(for: genreId) {
                    genres.append(genreName)
                }
            }
            genres.sort()
        } catch {
        }
        hasFetchedGenres = true
    }
    
    
    
    func makeDetailsViewModel() -> MovieDetailsViewModel {
        
        return MovieDetailsViewModel(movie.id, movieRep)
    }
    
    func makeCreditsViewModel() -> CreditsViewModel {
        
        return CreditsViewModel(movie.id, movieRep, imageRep)
    }
}
