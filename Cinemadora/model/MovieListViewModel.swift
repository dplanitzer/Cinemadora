//
//  MovieListViewModel.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/22/26.
//

import UIKit

@Observable
class MovieListViewModel {
    
    var movies: [Movie] = []
    
    var isLoading = false
    
    var hasMore: Bool {
        return nextPage < pageCount
    }
    
    var errorDescription = ""
    
    private let listName: ListName
    
    init(_ listName: ListName, _ movieRep: MovieRepository) {
        self.listName = listName
        self.movieRepository = movieRep
    }
    
    // Fetches the next page from movie list that this vide model represents. Does nothing
    // if no more data exists.
    func fetchMore() async {
        
        guard !isLoading && hasMore else { return }
        
        isLoading = true
        errorDescription = ""
        
        do {
            let r = try await movieRepository.fetchListPage(listName, nextPage)
            movies.append(contentsOf: r.movies)
            pageCount = r.pageCount
            nextPage += 1
            
        } catch {
            errorDescription = error.localizedDescription
        }
        
        isLoading = false
    }

    // Create a details view model for the given movie. The provided movie will be used
    // as an initial set of data to show to the user while the detail page is waiting
    // for the movie details to come down the wire.
    func makeDetailsViewModel(for movie: Movie) -> MovieDetailsViewModel {
        
        return MovieDetailsViewModel(movie, movieRepository)
    }
    
    
    private let movieRepository: MovieRepository
    
    private var nextPage = 0
    private var pageCount = 1
}
