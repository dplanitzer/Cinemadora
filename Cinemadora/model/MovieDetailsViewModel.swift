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
    
    
    // General movie details
    private(set) var details: MovieDetails?
    
    
    // Cast & Crew
    private(set) var cast: [CastMember] = []
    
    private(set) var crew: [CrewMember] = []

    private(set) var director: CrewMember?

    func image(for member: any Person) -> ImageLocator {
        
        return ImageLocator(imageRep, member.profilePath, .profile)
    }

    func makePersonDetailsViewModel(for personId: Int) -> PersonDetailsViewModel {
        
        return PersonDetailsViewModel(personId, movieRep, imageRep)
    }

    
    // Studios
    func image(for company: CompanySummary) -> ImageLocator {
        
        return ImageLocator(imageRep, company.logoPath, .logo)
    }

    
    // Reviews
    let reviewsFeed: ReviewsFeed

    
    
    func fetchDetails() async {
        
        guard details == nil else { return }
        
        do {
            details = try await movieRep.fetchMovieDetails(for: movieId)
            
            if let credits = details?.credits {
                director = credits.crew.first(where: { $0.job == "Director" })
                
                // Unqiue the cast and crew arrays. An person may appear more than once because
                // e.g. they played multiple roles
                cast = uniquePeople(credits.cast)
                crew = uniquePeople(credits.crew)
            }

            
            if reviewsFeed.items.isEmpty && reviewsFeed.hasMore && !reviewsFeed.isLoading {
                await reviewsFeed.fetchMore()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func uniquePeople<T: Person>(_ people: [T]) -> [T] {
       
        var r = [T]()
        var sawThem = Set<Int>()
        
        for p in people {
            if !sawThem.contains(p.id) {
                r.append(p)
                sawThem.insert(p.id)
            }
        }
        
        return r
    }
}
