//
//  CinemadoraApp.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/22/26.
//

import SwiftUI

@main
struct CinemadoraApp: App {
    
    var body: some Scene {
        WindowGroup {
            let token = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? ""
            let service = TMDBService(token)
            let movieRep = TMDBMovieRepository(service)
            let imageRep = TMDBImageRepository(service)
            let popularMoviesModel = MovieListViewModel(.popular, movieRep, imageRep)
            
            MovieListView(popularMoviesModel)
                .preferredColorScheme(.dark)
        }
    }
}
