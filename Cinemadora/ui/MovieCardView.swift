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
        
        VStack {
            Text(movie.title)
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 10.0)
            
            
            MovieGenresView(model)
                .padding(.leading, 10.0)
                .padding(.bottom, 10)

            
            HStack {
                if let voteAvg = movie.voteAverage {
                    RatingView(voteAverage: voteAvg, voteCount: movie.voteCount)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 10.0)
                }
                
                Spacer()
                
                Image("tmdb_short")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 70)
                    .padding(.trailing, 10.0)
            }
            .padding(.bottom, 10)
            
            
            MovieImageView(model)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
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
        movieState = try! await movieRep.fetchMovieListPage(.popular, 1).results.first!
    }
}
