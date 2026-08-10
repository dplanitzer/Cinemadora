//
//  StudioListView.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 8/9/26.
//

import SwiftUI

struct StudioListView: View {
    
    private var studios: [CompanySummary]
    private let imageResolver: (CompanySummary) -> ImageLocator

    
    init(_ studios: [CompanySummary], _ imageResolver: @escaping (CompanySummary) -> ImageLocator) {
        self.studios = studios
        self.imageResolver = imageResolver
    }
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(studios, id: \.id) { company in
                    AsyncImageView(imageResolver(company), size: .middle) { state in
                        switch state {
                        case .loaded(let image):
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                                    
                        default:
                            Color(white: 0.22)
                        }
                    }
                    .frame(width: 134, height: 38)
                    .background(Color(white: 1.0))
                    .padding(4)
                    .border(.white, width: 4)
                }
            }
            .padding(.horizontal)
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
    }
}


#Preview {
    @State @Previewable var movieDetails: MovieDetails? = nil
    let movieRep = MockMovieRepository()
    let imageRep = MockImageRepository()

    Group {
        if let details = movieDetails {
            StudioListView(details.productionCompanies, { company in
                ImageLocator(imageRep, company.logoPath, .logo)
            })
        } else {
            ProgressView()
        }
    }
    .preferredColorScheme(.dark)
    .task {
        movieDetails = try! await movieRep.fetchMovieDetails(for: 550)
    }
}
