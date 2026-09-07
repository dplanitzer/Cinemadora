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
            let appContainer = AppContainer.production()
            let popularMoviesModel = MovieListViewModel(.popular, appContainer)
            
            MovieListScreen(popularMoviesModel)
                .preferredColorScheme(.dark)
        }
    }
}
