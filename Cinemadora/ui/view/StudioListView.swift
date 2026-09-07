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
        
        Carousel(
            items: studios,
            spacing: 16.0,
            content: { company in
                LogoView(company, imageResolver)
            }
        )
        .fixedSize(horizontal: false, vertical: true)
    }
}


#Preview("Success") {
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


#Preview("Failure") {
    @State @Previewable var movieDetails: MovieDetails? = nil
    let movieRep = MockMovieRepository()
    let imageRep = MockImageRepository()

    Group {
        if let details = movieDetails {
            StudioListView(details.productionCompanies, { company in
                ImageLocator(imageRep, "/does_not_exist", .logo)
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
