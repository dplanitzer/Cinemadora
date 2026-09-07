//
//  MovieCardView.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/26/26.
//

import SwiftUI

struct MovieCardView: View {
    
    private let movie: Movie
    private let genres: [Genre]
    private let posterImage: ImageLocator
    
    
    init(movie: Movie, genres: [Genre], posterImage: ImageLocator) {
        
        self.movie = movie
        self.genres = genres
        self.posterImage = posterImage
    }
    
    var body: some View {
        
        VStack(spacing: 18) {
            VStack(spacing: 18) {
                Text(movie.title)
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                
                Carousel(
                    items: genres,
                    spacing: 8.0,
                    content: { genre in
                        GenreView(genre)
                    },
                    placeholder: {
                        // Show an effectively invisible dummy genre so that we can keep the
                        // height of this UI element stable no matter whether the genres have
                        // already been loaded or not
                        GenreView.invisiblePlaceholder()
                    }
                )
                .fixedSize(horizontal: false, vertical: true)
                
                
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
            
            
            AsyncImageView(posterImage) { state in
                switch state {
                case .loading:
                    Color(white: 0.22)
                        .overlay {
                            ProgressView()
                                .tint(.white)
                        }
                    
                case .loaded(let image):
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()

                case .failed:
                    ZStack {
                        Color(white: 0.22)
                        Image(systemName: "photo.badge.exclamationmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 62, height: 62)
                            .foregroundColor(.white)
                    }

                default:
                    Color(white: 0.22)
                }
            }
            .frame(maxWidth: .infinity)
            .aspectRatio(0.66, contentMode: .fit)
            .clipShape(.rect(cornerRadius: 60.0))
        }
        .foregroundColor(.primary)
    }
}


#Preview {
    @State @Previewable var movieModel: MovieViewModel? = nil
    let appContainer = AppContainer.mocked()

    Group {
        if let model = movieModel {
            MovieCardView(movie: model.movie, genres: model.genres, posterImage: model.posterImage)
        } else {
            ProgressView()
        }
    }
    .preferredColorScheme(.dark)
    .task {
        let movie = try! await appContainer.movieRepository.fetchMovieListPage(for: .popular, 1).results.first!
        
        movieModel =  MovieViewModel(movie, appContainer)
        await movieModel?.fetchGenres()
    }
}
