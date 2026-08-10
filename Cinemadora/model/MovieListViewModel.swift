//
//  MovieListViewModel.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/22/26.
//

import Foundation

@Observable
final class MovieListViewModel {
    
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

    private(set) var errorDescription = ""

    private(set) var movieViewModels: [MovieViewModel] = []
    
    func movieViewModel(for id: Int) -> MovieViewModel? {
        
        for mvm in movieViewModels {
            if mvm.id == id {
                return mvm
            }
        }
        return nil
    }
    
    private(set) var isLoading = false
    
    var hasMore: Bool {
        return nextPage < pageCount
    }
    
    // Fetches the next page from the movie list. Does nothing if no more data exists.
    func fetchMore() async {
        
        guard !isLoading && hasMore else { return }
        
        isLoading = true
        errorDescription = ""
        
        do {
            let r = try await movieRep.fetchMovieListPage(for: listName, nextPage)
            
            for movie in r.results {
                movieViewModels.append(MovieViewModel(movie, movieRep, imageRep))
            }
            pageCount = r.totalPageCount
            nextPage += 1
            
        } catch {
            errorDescription = error.localizedDescription
        }
        
        isLoading = false
    }
}
