//
//  MovieImageView.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/23/26.
//

import SwiftUI

struct MovieImageView: View {
    
    @State private var model: ImageViewModel
    private let cornerRadius: CGFloat

    
    init(_ movie: Movie, _ imageRep: ImageRepository, cornerRadius: CGFloat = 20.0) {
        self.model = ImageViewModel(movie, imageRep, usage: .poster, size: .large)
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        
        Group {
            switch model.state {
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
                
            case .failed:
                Color.gray.opacity(0.3)
            }
        }
        .task {
            await model.fetchImage()
        }
    }
}


#Preview {
    @State @Previewable var movieState: Movie? = nil
    let movieRep = MockMovieRepository()
    let imageRep = MockImageRepository()

    Group {
        if let movie = movieState {
            MovieImageView(movie, imageRep)
        } else {
            ProgressView()
        }
    }
    .preferredColorScheme(.dark)
    .task {
        movieState = try! await movieRep.fetchListPage(.popular, 1).movies.first!
    }
}
