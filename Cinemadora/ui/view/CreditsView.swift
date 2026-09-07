//
//  CreditsView.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 8/1/26.
//

import SwiftUI

struct CreditsView<Target: NavigationTarget>: View {
    
    private let PROFILE_WIDTH = 72.0
    private let PROFILE_HEIGHT = 110.0
    
    private var namespace: Namespace.ID

    private let people: [any Person]
    private let imageResolver: (any Person) -> ImageLocator
    
    
    init(_ people: [any Person], _ imageResolver: @escaping (any Person) -> ImageLocator, _ namespace: Namespace.ID) {
        
        self.people = people
        self.imageResolver = imageResolver
        self.namespace = namespace
    }
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(people, id: \.id) { person in
                    NavigationLink(value: Target(id: person.id)) {
                        ProfileView(person, imageResolver)
                            .frame(width: PROFILE_WIDTH, height: PROFILE_HEIGHT)
                            .clipShape(.rect(cornerRadius: 10.0))
                            .matchedTransitionSource(id: person.id, in: namespace)
                    }
                    .buttonStyle(.plain)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
    }
}


private struct ProfileView: View {
    
    private var person: any Person
    private let imageResolver: (any Person) -> ImageLocator
    
    
    init(_ person: any Person, _ imageResolver: @escaping (any Person) -> ImageLocator) {
        self.person = person
        self.imageResolver = imageResolver
    }
    
    var body: some View {
        
        AsyncImageView(imageResolver(person), size: .middle) { state in
            switch state {
            case .loaded(let image):
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                            
            case .failed, .fallback:
                ZStack {
                    Color(white: 0.22)
                                
                    Circle()
                        .stroke(Color(white: 0.75), lineWidth: 2)
                        .frame(width: 50, height: 50)
                        .overlay {
                            Text(getInitials(person.name))
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                }
                            
            default:
                Color(white: 0.22)
            }
        }
    }
    
    private func getInitials(_ fullName: String) -> String {
        let components = fullName.split(separator: " ").map { $0 }
        
        guard let firstComponent = components.first,
              let firstInitial = firstComponent.first else {
            // this shouldn't happen in real life
            return ""
        }
        
        if components.count == 1 {
            return firstInitial.uppercased()
        }
        
        if let lastComponent = components.last,
           let lastInitial = lastComponent.first {
            return "\(firstInitial)\(lastInitial)".uppercased()
        }
        
        return firstInitial.uppercased()
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
