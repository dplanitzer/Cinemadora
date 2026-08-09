//
//  MovieDetailsViewModel.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/23/26.
//

import UIKit

@Observable
final class MovieDetailsViewModel {
        
    private let movieRep: MovieRepository
    private let imageRep: ImageRepository
    private let movieId: Int
    
    
    init(_ movieId: Int, _ movieRep: MovieRepository, _ imageRep: ImageRepository) {
        self.movieId = movieId
        self.movieRep = movieRep
        self.imageRep = imageRep
    }
    
    private(set) var details: MovieDetails?
    
    func fetchDetails() async {
        
        guard details == nil else { return }
        
        do {
            details = try await movieRep.fetchMovieDetails(for: movieId)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func image(for company: CompanySummary) -> ImageLocator {
        
        return ImageLocator(imageRep, company.logoPath, .logo)
    }
}
