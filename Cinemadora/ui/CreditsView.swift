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
    }
    
    @ViewBuilder
    private func showCredits() -> some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(persons, id: \.id) { person in
                    AsyncImageView(model.image(for: person), cornerRadius: 10.0)
                        .frame(width: 73.3, height: 110)
                }
            }
            .padding(.horizontal)
        }
    }
    
    var persons: [any Person] {
        switch creditsType {
        case .cast:
            return model.cast
            
        case .crew:
            return model.crew
        }
    }
}


#Preview {
    CreditsView(CreditsViewModel(550, MockMovieRepository(), MockImageRepository()), .cast)
        .preferredColorScheme(.dark)
}
