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

        return AppContainer(dataSource, TMDBImageRepository(dataSource))
    }
    
    
    static func mocked() -> AppContainer {
        
        return AppContainer(MockDataSource(), MockImageRepository())
    }

    
    private init(_ dataSource: DataSource, _ imageRepository: ImageRepository) {

        self.movieRepository = MovieRepository(dataSource)
        self.imageRepository = imageRepository
        self.genreRepository = GenreRepository(dataSource)
        self.reviewRepository = ReviewRepository(dataSource)
        self.companyRepository = CompanyRepository(dataSource)
        self.personRepository = PersonRepository(dataSource)
    }
    
    
    let movieRepository: MovieRepository
    let imageRepository: ImageRepository
    let genreRepository: GenreRepository
    let reviewRepository: ReviewRepository
    let companyRepository: CompanyRepository
    let personRepository: PersonRepository
}
