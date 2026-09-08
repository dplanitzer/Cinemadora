//
//  MoviesFeed.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 9/8/26.
//

import Foundation

@Observable
final class MoviesFeed : Feed {
    
    private let dataSource: DataSource

    private let listName: ListName
    private var nextPage = 0
    private var pageCount = 1

    
    init(_ dataSource: DataSource, _ listName: ListName) {

        self.dataSource = dataSource
        self.listName = listName
    }

    private(set) var errorDescription = ""

    private(set) var items: [Movie] = []
    
    func movie(for id: Int) -> Movie? {
        
        for mv in items {
            if mv.id == id {
                return mv
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
            let r = try await dataSource.fetchMovieListPage(for: listName, nextPage)
            
            for movie in r.results {
                items.append(movie)
            }
            pageCount = r.totalPageCount
            nextPage += 1
            
        } catch {
            errorDescription = error.localizedDescription
        }
        
        isLoading = false
    }
}
