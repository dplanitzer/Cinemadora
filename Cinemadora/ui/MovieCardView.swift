//
//  MovieCardView.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/26/26.
//

import SwiftUI

struct MovieCardView: View {
    
    @State private var model: MovieViewModel
    
    
    init(_ model: MovieViewModel) {
        self.model = model
    }
    
    var body: some View {
        
        let movie = model.movie
        
        VStack(spacing: 18) {
            VStack(spacing: 18) {
                Text(movie.title)
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                
                MovieGenresView(model)
                
                
                HStack {
                    if let voteAvg = movie.voteAverage {
                        RatingView(voteAverage: voteAvg)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Spacer()
                    
                    Image("tmdb_short")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 70)
                }
            }
            .padding(.horizontal, 10.0)
            
            
            AsyncImageView(model.posterImage, cornerRadius: 60.0)
        }
        .foregroundColor(.primary)
    }
}


#Preview {
    @State @Previewable var movieState: Movie? = nil
    let movieRep = MockMovieRepository()

    Group {
        if let movie = movieState {
            MovieCardView(MovieViewModel(movie, movieRep, MockImageRepository()))
        } else {
            ProgressView()
        }
    }
    .preferredColorScheme(.dark)
    .task {
        movieState = try! await movieRep.fetchMovieListPage(for: .popular, 1).results.first!
    }
}
