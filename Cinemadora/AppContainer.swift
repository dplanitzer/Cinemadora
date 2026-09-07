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
        let service = TMDBService(token)
        let movieRep = TMDBMovieRepository(service)
        let imageRep = TMDBImageRepository(service)

        return AppContainer(movieRepository: movieRep, imageRepository: imageRep)
    }
    
    
    static func mocked() -> AppContainer {
        
        let movieRep = MockMovieRepository()
        let imageRep = MockImageRepository()

        return AppContainer(movieRepository: movieRep, imageRepository: imageRep)
    }

    
    let movieRepository: MovieRepository
    let imageRepository: ImageRepository
}
