//
//  PersonDetailsViewModel.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 8/10/26.
//

import Foundation

@Observable
final class PersonDetailsViewModel : Identifiable {
        
    private let movieRep: MovieRepository
    private let imageRep: ImageRepository
    
    
    init(_ personId: Int, _ movieRep: MovieRepository, _ imageRep: ImageRepository) {
        self.id = personId
        self.movieRep = movieRep
        self.imageRep = imageRep
    }
    
    private(set) var details: PersonDetails?
    
    func fetchDetails() async {
        
        guard details == nil else { return }
        
        do {
            details = try await movieRep.fetchPersonDetails(for: id)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    let id: Int

    var profileImage: ImageLocator {
        
        return ImageLocator(imageRep, details?.profilePath, .profile)
    }
}
