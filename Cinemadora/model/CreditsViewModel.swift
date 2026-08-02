//
//  CreditsViewModel.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 8/1/26.
//

import Foundation

@Observable
final class CreditsViewModel {
    
    private let movieRep: MovieRepository
    private let imageRep: ImageRepository
    private let movieId: Int
    private var credits: Credits?
        
    
    init(_  movieId: Int, _ movieRep: MovieRepository, _ imageRep: ImageRepository) {
        self.movieId = movieId
        self.movieRep = movieRep
        self.imageRep = imageRep
    }

    var hasFetchedCredits: Bool {
        
        return credits != nil
    }
    
    private(set) var cast: [CastMember] = []
    
    private(set) var crew: [CrewMember] = []

    func image(for member: any Person) -> ImageLocator {
        
        return ImageLocator(imageRep, member.profilePath, .profile)
    }

    func fetchCredits() async {
        
        guard credits == nil else { return }
        
        do {
            credits = try await movieRep.fetchCredits(for: movieId)
            
            // Unqiue the cast and crew arrays. An person may appear more than once because
            // e.g. they played multiple roles
            cast = uniquePeople(credits!.cast)
            crew = uniquePeople(credits!.crew)
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
