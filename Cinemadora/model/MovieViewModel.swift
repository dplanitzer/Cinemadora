//
//  MovieViewModel.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/29/26.
//

import Foundation

@Observable
final class MovieViewModel : Identifiable {
    
    private let appContainer: AppContainer
        
    
    init(_  movie: Movie, _ appContainer: AppContainer) {
        
        self.movie = movie
        self.appContainer = appContainer
        self.posterImage = ImageLocator(appContainer.imageRepository, movie.posterPath, .poster)
    }

    var id: Int {
        return movie.id
    }

    let movie: Movie
    
    let posterImage: ImageLocator

    var releaseYear: String {
        return String(movie.releaseDate?.split(separator: "-").first ?? "????")
    }
    
    private(set) var hasFetchedGenres: Bool = false
    
    // Loaded genres, sorted by name
    private(set) var genres: [Genre] = []

    func fetchGenres() async {
        
        guard !hasFetchedGenres else { return }
        
        do {
            genres = []
            for genreId in movie.genreIds {
                if let genre = try await appContainer.genreRepository.genre(for: genreId) {
                    genres.append(genre)
                }
            }
            genres.sort { $0.name < $1.name }
        } catch {
        }
        hasFetchedGenres = true
    }
    
        
    func makeDetailsViewModel() -> MovieDetailsViewModel {
        
        return MovieDetailsViewModel(movie.id, appContainer)
    }
}
