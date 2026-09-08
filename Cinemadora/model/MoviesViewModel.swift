//
//  MoviesViewModel.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 9/8/26.
//

import Foundation

@Observable
final class MoviesViewModel {
    
    private let appContainer: AppContainer
    
    
    init(_ listName: ListName, _ appContainer: AppContainer) {
        
        self.appContainer = appContainer
        self.moviesFeed = appContainer.movieRepository.moviesFeed(for: listName)
    }

    let moviesFeed: MoviesFeed
    
    func posterImage(for movie: Movie) -> ImageLocator {
        
        return ImageLocator(appContainer.imageRepository, movie.posterPath, .poster)
    }
    
    func genresFeed(for movie: Movie) -> GenresFeed {
        
        return appContainer.genreRepository.genresFeed(for: movie)
    }
    
        
    func makeDetailsViewModel(for movie: Movie) -> MovieDetailsViewModel {
        
        return MovieDetailsViewModel(movie, posterImage(for: movie), appContainer)
    }
}
