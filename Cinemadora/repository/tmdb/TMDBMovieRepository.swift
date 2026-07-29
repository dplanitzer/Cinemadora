//
//  TMDBRepository.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/22/26.
//

import Foundation

final class TMDBMovieRepository : MovieRepository {
    
    private let service: TMDBService
    
    init(_ service: TMDBService) {
        self.service = service
    }
    
    func fetchListPage(_ list: ListName, _ pageNum: Int) async throws -> ListPage {
        
        let langReg = NSLocale.preferredLanguages.first ?? "en-US"
        let listName: String
        
        switch (list) {
        case .popular:  listName = "popular"
        case .upcoming: listName = "upcoming"
        case .topRated: listName = "top_rated"
        }

        let r = try await service.fetch(from: "https://api.themoviedb.org/3/movie/\(listName)?language=\(langReg)&page=\(pageNum + 1)", type: MovieListResponse<Movie>.self)
        return ListPage(movies: r.results, pageCount: r.totalPageCount)
    }
}
