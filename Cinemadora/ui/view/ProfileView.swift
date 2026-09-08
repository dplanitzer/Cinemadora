//
//  ProfileView.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 9/6/26.
//

import SwiftUI

struct ProfileView: View {
    
    private let PROFILE_WIDTH = 72.0
    private let PROFILE_HEIGHT = 110.0

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
        .frame(width: PROFILE_WIDTH, height: PROFILE_HEIGHT)
        .clipShape(.rect(cornerRadius: 10.0))
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
    @State @Previewable var mvm = MoviesViewModel(.popular, AppContainer.mocked())
    @State @Previewable var dvm: MovieDetailsViewModel? = nil
    
    VStack {
        if mvm.moviesFeed.items.first != nil {
            if let dvm = dvm {
                if let person = dvm.cast.first {
                    ProfileView(person, dvm.image(for:))
                } else {
                    Text("No person")
                }
            } else {
                ProgressView("Loading movie details...")
            }
        } else {
            ProgressView("Fetching movies feed...")
        }
    }
    .preferredColorScheme(.dark)
    .task {
        await mvm.moviesFeed.fetchMore()
        
        if let movie = mvm.moviesFeed.items.first {
            let loadedDvm = mvm.makeDetailsViewModel(for: movie)
            
            await loadedDvm.fetchDetails()
            dvm = loadedDvm
        }
    }
}


