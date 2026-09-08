//
//  PersonDetailsScreen.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 8/10/26.
//

import SwiftUI

struct PersonDetailsScreen: View {
    
    @State private var model: PersonDetailsViewModel
    var namespace: Namespace.ID

    
    init(_ model: PersonDetailsViewModel, _ namespace: Namespace.ID) {
        
        self.model = model
        self.namespace = namespace
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                AsyncImageView(model.profileImage) { state in
                    switch state {
                    case .loaded(let image):
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                                    
                    default:
                        Color(white: 0.22)
                    }
                }
                .frame(maxWidth: .infinity)
                .aspectRatio(0.66, contentMode: .fit)
                .clipShape(.rect(cornerRadius: 60.0))
                .ignoresSafeArea(edges: [.top, .horizontal])
                .id(model.details?.profilePath)
                
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: max(geometry.size.height * 0.48 - 30, 0))
                    
                    LinearGradient(
                        colors: [.clear, .black],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 30)
                    
                    ScrollView {
                        if let details = model.details {
                            PersonInfoView(details)
                        }
                    }
                    .scrollIndicators(.hidden)
                    .offset(y: -30)
                    .background(.background)
                    .ignoresSafeArea(edges: .bottom)
                }
            }
            .navigationTransition(.zoom(sourceID: model.id, in: namespace))
        }
        .task {
            await model.fetchDetails()
        }
    }
}


private struct PersonInfoView: View {
    
    private let details: PersonDetails

    
    init(_ details: PersonDetails) {
        self.details = details
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 28) {
            Text(details.name)
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                    
            Text(details.biography)
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading) 
        }
        .padding(.horizontal, 10)
    }
}


#Preview {
    let appContainer = AppContainer.mocked()
    
    PreviewWrapper(PersonDetailsViewModel(31, appContainer)) { model, namespace in
        PersonDetailsScreen(model, namespace)
    }
}
