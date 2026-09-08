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
    private var genresCache = Dictionary<Int, [Genre]>()
    
    
    init(_ listName: ListName, _ appContainer: AppContainer) {
        
        self.appContainer = appContainer
        self.moviesFeed = appContainer.movieRepository.moviesFeed(for: listName)
    }

    let moviesFeed: MoviesFeed
        
    func posterImage(for movie: Movie) -> ImageLocator {
        
        return ImageLocator(appContainer.imageRepository, movie.posterPath, .poster)
    }
    
    func genres(for movie: Movie) -> [Genre] {
        
        return genresCache[movie.id] ?? []
    }
    
    func hasFetchedGenres(for movie: Movie) -> Bool {
        
        if genresCache[movie.id] != nil {
            return true
        } else {
            return false
        }
    }
    
    func fetchGenres(for movie: Movie) async {
        
        guard !hasFetchedGenres(for: movie) else { return }
        
        do {
            var theGenres = [Genre]()
            
            for genreId in movie.genreIds {
                if let genre = try await appContainer.genreRepository.genre(for: genreId) {
                    theGenres.append(genre)
                }
            }
            theGenres.sort { $0.name < $1.name }
            genresCache[movie.id] = theGenres
        } catch {
        }
    }
    
        
    func makeDetailsViewModel(for movie: Movie) -> MovieDetailsViewModel {
        
        return MovieDetailsViewModel(movie, genres(for: movie), posterImage(for: movie), appContainer)
    }
}
