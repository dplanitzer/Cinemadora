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
            
            
            if model.hasFetchedGenres {
                HStack(spacing: 10) {
                    ForEach(model.genres, id: \.self) { genre in
                        GenreView(genre)
                    }
                    
                    Spacer()
                }
                .padding(.leading, 10.0)
                .padding(.bottom, 10)
            }
            
            
            HStack {
                RatingView(voteAverage: movie.voteAverage, voteCount: movie.voteCount)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 10.0)
                
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
        .task {
            await model.fetchGenres()
        }
    }
}


#Preview {
    @State @Previewable var movieState: Movie? = nil
    let movieRep = MockMovieRepository()
    let imageRep = MockImageRepository()

    Group {
        if let movie = movieState {
            MovieCardView(MovieViewModel(movie, movieRep, imageRep))
        } else {
            ProgressView()
        }
    }
    .preferredColorScheme(.dark)
    .task {
        movieState = try! await movieRep.fetchListPage(.popular, 1).movies.first!
    }
}
