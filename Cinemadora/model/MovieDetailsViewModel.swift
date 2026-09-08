//
//  MovieDetailsViewModel.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/23/26.
//

import Foundation

@Observable
final class MovieDetailsViewModel {
    
    private let appContainer: AppContainer
    
    
    init(_ movie: Movie, _ genres: [Genre], _ posterImage: ImageLocator, _ appContainer: AppContainer) {

        self.movie = movie
        self.genres = genres
        self.posterImage = posterImage
        self.appContainer = appContainer
        self.reviewsFeed = appContainer.reviewRepository.reviewsFeed(for: movie.id)
    }
    

    // Basic movie information (synchronously available)
    let movie: Movie
    
    // Movie genres (synchronously available)
    let genres: [Genre]
    
    // Movie poster image (synchronously available)
    let posterImage: ImageLocator
    
    var releaseYear: String {

        return String(movie.releaseDate?.split(separator: "-").first ?? "????")
    }

    
    // General movie details
    private(set) var details: MovieDetails?
    
    
    // Cast & Crew
    private(set) var cast: [CastMember] = []
    
    private(set) var crew: [CrewMember] = []

    private(set) var director: CrewMember?

    func image(for member: any Person) -> ImageLocator {
        
        return ImageLocator(appContainer.imageRepository, member.profilePath, .profile)
    }

    func makePersonDetailsViewModel(for personId: Int) -> PersonDetailsViewModel {
        
        return PersonDetailsViewModel(personId, appContainer)
    }

    
    // Studios
    private(set) var productionCompanies: [CompanySummary] = []
    
    func image(for company: CompanySummary) -> ImageLocator {
        
        return ImageLocator(appContainer.imageRepository, company.logoPath, .logo)
    }

    
    // Reviews
    let reviewsFeed: ReviewsFeed

    
    
    func fetchDetails() async {
        
        guard details == nil else { return }
        
        do {
            details = try await appContainer.movieRepository.fetchMovieDetails(for: movie.id)
            
            if let credits = details?.credits {
                director = credits.crew.first(where: { $0.job == "Director" })
                
                // Unqiue the cast and crew arrays. An person may appear more than once because
                // e.g. they played multiple roles
                cast = uniquePeople(credits.cast)
                crew = uniquePeople(credits.crew)
            }
            
            if let companies = details?.productionCompanies {
                productionCompanies = companies
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
