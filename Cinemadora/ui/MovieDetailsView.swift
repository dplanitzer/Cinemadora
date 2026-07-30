//
//  MovieDetailsView.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/23/26.
//

import SwiftUI

struct MovieDetailsView: View {
    
    @State private var model: MovieViewModel
    @State private var detailsModel: MovieDetailsViewModel

    
    init(_ model: MovieViewModel) {
        self.model = model
        self.detailsModel = model.makeDetailsViewModel(for: model.movie)
    }
    
    var body: some View {
        let movie = model.movie
        
        VStack {
            MovieImageView(model)
                .frame(maxWidth: .infinity)
                .frame(height: 300)

            ScrollView {
                VStack(alignment: .leading) {
                    Text(movie.title)
                        .font(.title)
                        .bold()
                        .padding(.bottom, 18)
                    
                    MovieGenresView(model)
                        .padding(.leading, 10.0)
                        .padding(.bottom, 14)

                    RatingView(voteAverage: movie.voteAverage, voteCount: movie.voteCount)
                        .padding(.bottom, 14)
                    
                    Text("Release Year")
                        .font(.headline)
                        .bold()
                        .padding(.bottom, 4)
                    
                    Text(movie.releaseDate)
                        .font(.body)
                        .padding(.bottom, 14)

                    Text("Overview")
                        .font(.headline)
                        .bold()
                        .padding(.bottom, 4)
                    
                    Text(movie.overview)
                        .font(.body)
                }
            }
        }
    }
}


#Preview {
    @State @Previewable var movieState: Movie? = nil
    let movieRep = MockMovieRepository()
    let imageRep = MockImageRepository()

    Group {
        if let movie = movieState {
            MovieDetailsView(MovieViewModel(movie, movieRep, imageRep))
        } else {
            ProgressView()
        }
    }
    .preferredColorScheme(.dark)
    .task {
        movieState = try! await movieRep.fetchListPage(.popular, 1).movies.first!
    }
}
