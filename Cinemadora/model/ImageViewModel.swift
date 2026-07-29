//
//  ImageViewModel.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/26/26.
//

import UIKit

enum ImageState : Equatable {
    case idle
    case loading
    case loaded(image: UIImage)
    case failed(error: String)
}


@Observable
final class ImageViewModel {
    
    private let repository: ImageRepository
    private let movie: Movie
    private let usage: ImageUsage
    private let size: ImageSizeClass
    
    var state: ImageState = .idle
    
    init(_  movie: Movie, _ imageRep: ImageRepository, usage: ImageUsage = .poster, size: ImageSizeClass = .middle) {
        self.repository = imageRep
        self.movie = movie
        self.usage = usage
        self.size = size
    }
    
    func fetchImage() async {
        
        state = .loading
        
        
        let basePath: String
        
        switch usage {
        case .backdrop:
            if movie.backdropPath == nil {
                state = .failed(error: URLError(.cannotLoadFromNetwork).localizedDescription)
                return
            }
            basePath = movie.backdropPath!

        default:
            basePath = movie.posterPath
        }

        
        do {
            state = .loaded(image: try await repository.image(for: basePath, usage: usage, size: size))
        } catch {
            state = .failed(error: error.localizedDescription)
        }
    }
}
