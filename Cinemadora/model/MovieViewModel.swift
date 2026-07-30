//
//  MovieViewModel.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/29/26.
//

import UIKit

enum ImageState : Equatable {
    case idle
    case loading
    case loaded(image: UIImage)
    case failed(error: String)
}


@Observable
final class MovieViewModel {
    
    private let movieRep: MovieRepository
    private let imageRep: ImageRepository
        
    
    init(_  movie: Movie, _ movieRep: MovieRepository, _ imageRep: ImageRepository) {
        self.movie = movie
        self.movieRep = movieRep
        self.imageRep = imageRep
    }

    let movie: Movie

    
    var posterImage: ImageState = .idle

    func fetchPosterImage() async {
        
        posterImage = .loading
        
        do {
            posterImage = .loaded(image: try await imageRep.image(for: movie.posterPath, usage: .poster, size: .large))
        } catch {
            posterImage = .failed(error: error.localizedDescription)
        }
    }

    
    var hasFetchedGenres: Bool = false
    
    // Loaded genres, sorted by name
    var genres: [String] = []

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
    
    
    
    // Create a details view model for the given movie. The provided movie will be used
    // as an initial set of data to show to the user while the detail page is waiting
    // for the movie details to come down the wire.
    func makeDetailsViewModel(for movie: Movie) -> MovieDetailsViewModel {
        
        return MovieDetailsViewModel(movie, movieRep)
    }
}
