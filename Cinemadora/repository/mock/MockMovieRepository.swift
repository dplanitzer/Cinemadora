//
//  MockRepository.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/22/26.
//

import Foundation

final class MockMovieRepository : MovieRepository {
    
    func fetchListPage(_ list: ListName, _ pageNum: Int) async throws -> ListPage {
        
        guard let url = Bundle.main.url(forResource: "popular_movies", withExtension: "json") else {
            throw RepositoryError(URLError(.fileDoesNotExist))
        }

        do {
            let data = try Data(contentsOf: url)
            let r = try JSONDecoder().decode(MovieListResponse<Movie>.self, from: data)

            try await Task.sleep(nanoseconds: 1_500_000_000)
            return ListPage(movies: r.results, pageCount: r.totalPageCount)
        } catch {
            throw RepositoryError(error, url: url)
        }
    }
}
