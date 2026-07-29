//
//  MovieCardView.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/26/26.
//

import SwiftUI

struct MovieCardView: View {
    
    private let movie: Movie
    private let imageRep: ImageRepository
    
    
    init(_ movie: Movie, _ imageRep: ImageRepository) {
        self.movie = movie
        self.imageRep = imageRep
    }
    
    var body: some View {
        
        VStack {
            Text(movie.title)
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 10.0)
            
            HStack {
                RatingView(movie)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 10.0)
                
                Image("tmdb_short")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 70)
                    .padding(.trailing, 10.0)
            }
            .padding(.bottom, 10)
            
            MovieImageView(movie, imageRep)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
        .foregroundColor(.primary)
    }
}


#Preview {
    @State @Previewable var movieState: Movie? = nil
    let movieRep = MockMovieRepository()
    let imageRep = MockImageRepository()

    Group {
        if let movie = movieState {
            MovieCardView(movie, imageRep)
        } else {
            ProgressView()
        }
    }
    .preferredColorScheme(.dark)
    .task {
        movieState = try! await movieRep.fetchListPage(.popular, 1).movies.first!
    }
}
