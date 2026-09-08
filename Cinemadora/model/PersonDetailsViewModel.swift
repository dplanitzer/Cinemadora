//
//  PersonDetailsViewModel.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 8/10/26.
//

import Foundation

@Observable
final class PersonDetailsViewModel : Identifiable {
    
    private let appContainer: AppContainer
    
    
    init(_ personId: Int, _ appContainer: AppContainer) {
        
        self.id = personId
        self.appContainer = appContainer
    }
    
    private(set) var details: PersonDetails?
    
    func fetchDetails() async {
        
        guard details == nil else { return }
        
        do {
            details = try await appContainer.personRepository.fetchPersonDetails(for: id)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    let id: Int

    var profileImage: ImageLocator {
        
        return ImageLocator(appContainer.imageRepository, details?.profilePath, .profile)
    }
}
