//
//  MovieGenresView.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/30/26.
//

import SwiftUI

struct MovieGenresView: View {
    
    private let model: MovieViewModel
    
    
    init(_ model: MovieViewModel) {
        self.model = model
    }
    
    var body: some View {
        
        if model.hasFetchedGenres {
            GenreListView(model.genres)
        } else {
            // Show an effectively invisible dummy genre so that we can keep the
            // height of this UI element stable no matter whether the genres have
            // already been loaded or not
            GenreListView(["Dummy"])
                .opacity(0.0)
                .task {
                    await model.fetchGenres()
                }
        }
    }
}


#Preview {
    @State @Previewable var movieState: Movie? = nil
    let movieRep = MockMovieRepository()

    Group {
        if let movie = movieState {
            MovieGenresView(MovieViewModel(movie, movieRep, MockImageRepository()))
        } else {
            ProgressView()
        }
    }
    .preferredColorScheme(.dark)
    .task {
        movieState = try! await movieRep.fetchMovieListPage(for: .popular, 1).results.first!
    }
}
