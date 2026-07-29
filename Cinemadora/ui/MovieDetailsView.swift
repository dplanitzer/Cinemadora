//
//  MovieDetailsView.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/23/26.
//

import SwiftUI

struct MovieDetailsView: View {
    
    @State private var model: MovieDetailsViewModel
    private let imageRep: ImageRepository

    
    init(_ model: MovieDetailsViewModel, _ imageRep: ImageRepository) {
        self.model = model
        self.imageRep = imageRep
    }
    
    var body: some View {
        let movie = model.movie
        
        VStack {
            MovieImageView(model.movie, imageRep)
                .frame(maxWidth: .infinity)
                .frame(height: 300)

            ScrollView {
                VStack(alignment: .leading) {
                    Text(movie.title)
                        .font(.title)
                        .bold()
                        .padding(.bottom, 18)
                    
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
            MovieDetailsView(MovieDetailsViewModel(movie, movieRep), imageRep)
        } else {
            ProgressView()
        }
    }
    .preferredColorScheme(.dark)
    .task {
        movieState = try! await movieRep.fetchListPage(.popular, 1).movies.first!
    }
}
