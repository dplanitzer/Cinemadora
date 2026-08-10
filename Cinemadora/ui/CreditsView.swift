//
//  CreditsView.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 8/1/26.
//

import SwiftUI

enum CreditsType {
    case cast
    case crew
}


struct CreditsView: View {
    
    private let PROFILE_WIDTH = 72.0
    private let PROFILE_HEIGHT = 110.0
    
    @State private var model: CreditsViewModel
    private let creditsType: CreditsType
    
    
    init(_ model: CreditsViewModel, _ type: CreditsType) {
        self.model = model
        self.creditsType = type
    }
    
    var body: some View {
        
        if model.hasFetchedCredits {
            showCredits()
        }
        else {
            showPlaceholder()
                .task {
                    await model.fetchCredits()
                }
        }
    }
    
    @ViewBuilder
    private func showPlaceholder() -> some View {
        
        ProgressView()
            .frame(maxWidth: .infinity)
            .frame(height: PROFILE_HEIGHT)
    }
    
    @ViewBuilder
    private func showCredits() -> some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(persons, id: \.id) { person in
                    AsyncImageView(model.image(for: person), size: .middle) { state in
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
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
    }
    
    var persons: [any Person] {
        switch creditsType {
        case .cast:
            return model.cast
            
        case .crew:
            return model.crew
        }
    }
    
    func getInitials(_ fullName: String) -> String {
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
    CreditsView(CreditsViewModel(550, MockMovieRepository(), MockImageRepository()), .cast)
        .preferredColorScheme(.dark)
}
