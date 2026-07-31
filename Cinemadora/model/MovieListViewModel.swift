//
//  MovieListViewModel.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/22/26.
//

import UIKit

@Observable
class MovieListViewModel {
    
    private let listName: ListName
    private let movieRep: MovieRepository
    private let imageRep: ImageRepository
    
    private var nextPage = 0
    private var pageCount = 1

    
    init(_ listName: ListName, _ movieRep: MovieRepository, _ imageRep: ImageRepository) {
        self.listName = listName
        self.movieRep = movieRep
        self.imageRep = imageRep
    }

    var errorDescription = ""

    var movieViewModels: [MovieViewModel] = []
    
    func movieViewModel(for id: Int) -> MovieViewModel? {
        
        for mvm in movieViewModels {
            if mvm.id == id {
                return mvm
            }
        }
        return nil
    }
    
    var isLoading = false
    
    var hasMore: Bool {
        return nextPage < pageCount
    }
    
    // Fetches the next page from movie list that this vide model represents. Does nothing
    // if no more data exists.
    func fetchMore() async {
        
        guard !isLoading && hasMore else { return }
        
        isLoading = true
        errorDescription = ""
        
        do {
            let r = try await movieRep.fetchListPage(listName, nextPage)
            
            for movie in r.results {
                movieViewModels.append(makeMovieViewModel(for: movie))
            }
            pageCount = r.totalPageCount
            nextPage += 1
            
        } catch {
            errorDescription = error.localizedDescription
        }
        
        isLoading = false
    }

    // Create a regular view model for the given movie. This view model provides
    // basic information about the movie.
    private func makeMovieViewModel(for movie: Movie) -> MovieViewModel {
        
        return MovieViewModel(movie, movieRep, imageRep)
    }
}
