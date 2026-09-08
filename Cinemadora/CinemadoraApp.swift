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
            MovieListScreen(MoviesViewModel(.popular, AppContainer.production()))
                .preferredColorScheme(.dark)
        }
    }
}
