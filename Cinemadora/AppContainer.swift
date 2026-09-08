//
//  AppContainer.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 9/6/26.
//

import Foundation

struct AppContainer {
    
    static func production() -> AppContainer {
        
        let token = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? ""
        let dataSource = TMDBDataSource(token)

        return AppContainer(
            movieRepository: TMDBMovieRepository(dataSource),
            imageRepository: TMDBImageRepository(dataSource),
            genreRepository: TMDBGenreRepository(dataSource),
            reviewRepository: TMDBReviewRepository(dataSource),
            companyRepository: TMDBCompanyRepository(dataSource),
            personRepository: TMDBPersonRepository(dataSource)
        )
    }
    
    
    static func mocked() -> AppContainer {
        
        let dataSource = MockDataSource()

        return AppContainer(
            movieRepository: MockMovieRepository(dataSource),
            imageRepository: MockImageRepository(),
            genreRepository: MockGenreRepository(dataSource),
            reviewRepository: MockReviewRepository(dataSource),
            companyRepository: MockCompanyRepository(dataSource),
            personRepository: MockPersonRepository(dataSource)
        )
    }

    
    let movieRepository: MovieRepository
    let imageRepository: ImageRepository
    let genreRepository: GenreRepository
    let reviewRepository: ReviewRepository
    let companyRepository: CompanyRepository
    let personRepository: PersonRepository
}
