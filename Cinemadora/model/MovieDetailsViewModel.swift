//
//  MovieDetailsViewModel.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/23/26.
//

import Foundation

@Observable
final class MovieDetailsViewModel {
        
    private let movieRep: MovieRepository
    private let imageRep: ImageRepository
    private let movieId: Int
    
    
    init(_ movieId: Int, _ movieRep: MovieRepository, _ imageRep: ImageRepository) {
        
        self.movieId = movieId
        self.movieRep = movieRep
        self.imageRep = imageRep
        self.reviewsFeed = movieRep.reviewsFeed(for: movieId)
    }
    
    
    private(set) var details: MovieDetails?
    
    let reviewsFeed: ReviewsFeed

    func image(for company: CompanySummary) -> ImageLocator {
        
        return ImageLocator(imageRep, company.logoPath, .logo)
    }

    
    func fetchDetails() async {
        
        guard details == nil else { return }
        
        do {
            details = try await movieRep.fetchMovieDetails(for: movieId)
            
            if reviewsFeed.items.isEmpty && reviewsFeed.hasMore && !reviewsFeed.isLoading {
                await reviewsFeed.fetchMore()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
