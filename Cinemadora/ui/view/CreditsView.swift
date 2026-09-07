//
//  CreditsView.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 8/1/26.
//

import SwiftUI

struct CreditsView<Target: NavigationTarget>: View {
        
    private var namespace: Namespace.ID

    private let people: [any Person]
    private let imageResolver: (any Person) -> ImageLocator
    
    
    init(_ people: [any Person], _ imageResolver: @escaping (any Person) -> ImageLocator, _ namespace: Namespace.ID) {
        
        self.people = people
        self.imageResolver = imageResolver
        self.namespace = namespace
    }
    
    var body: some View {
        
        Carousel(
            items: people,
            id: \.id,
            spacing: 16.0,
            content: { person in
                NavigationLink(value: Target(id: person.id)) {
                    ProfileView(person, imageResolver)
                        .matchedTransitionSource(id: person.id, in: namespace)
                }
                .buttonStyle(.plain)
            }
        )
        .fixedSize(horizontal: false, vertical: true)
    }
}


#Preview {
    @State @Previewable var detailsModel = MovieDetailsViewModel(550, MockMovieRepository(), MockImageRepository())

    Group {
        if let details = detailsModel.details {
            PreviewWrapper(details) { model, namespace in
                CreditsView<CastMemberDetailsTarget>(
                    detailsModel.cast,
                    { (person: any Person) in
                        return detailsModel.image(for: person)
                    },
                    namespace
                )
            }
        } else {
            ProgressView()
        }
    }
    .preferredColorScheme(.dark)
    .task {
        await detailsModel.fetchDetails()
    }
}
