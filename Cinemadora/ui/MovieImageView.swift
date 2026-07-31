//
//  MovieImageView.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/23/26.
//

import SwiftUI

struct MovieImageView: View {
    
    @State private var model: MovieViewModel
    private let cornerRadius: CGFloat

    
    init(_ model: MovieViewModel, cornerRadius: CGFloat = 20.0) {
        self.model = model
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        
        Group {
            switch model.posterImage {
            case .idle:
                Color.gray.opacity(0.2)
                
            case .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            case .loaded(let image):
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .clipShape(.rect(cornerRadius: cornerRadius))
                
            case .fallback:
                Color.black

            case .failed:
                Color.gray.opacity(0.3)
            }
        }
        .task {
            await model.fetchPosterImage()
        }
    }
}


#Preview {
    @State @Previewable var movieState: Movie? = nil
    let movieRep = MockMovieRepository()

    Group {
        if let movie = movieState {
            MovieImageView(MovieViewModel(movie, movieRep, MockImageRepository()))
        } else {
            ProgressView()
        }
    }
    .preferredColorScheme(.dark)
    .task {
        movieState = try! await movieRep.fetchListPage(.popular, 1).movies.first!
    }
}
