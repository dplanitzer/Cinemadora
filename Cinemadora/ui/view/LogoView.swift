//
//  LogoView.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 9/6/26.
//

import SwiftUI

struct LogoView: View {
    
    private let LOGO_WIDTH = 134.0
    private let LOGO_HEIGHT = 38.0
    
    private let company: CompanySummary
    private let imageResolver: (CompanySummary) -> ImageLocator

    
    init(_ company: CompanySummary, _ imageResolver: @escaping (CompanySummary) -> ImageLocator) {
        
        self.company = company
        self.imageResolver = imageResolver
    }
    
    var body: some View {
        
        AsyncImageView(imageResolver(company), size: .middle) { state in
            switch state {
            case .loaded(let image):
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                                  
            case .failed, .fallback:
                Text(company.name)
                    .font(.system(size: 14, weight: .medium))
                    .lineLimit(2)
                    .minimumScaleFactor(0.4)    // Let the font auto-scale down to ensure that the text doesn't get clipped
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.black)
                    .padding(.horizontal, 2)
                        
            default:
                Color.white
            }
        }
        .frame(width: LOGO_WIDTH, height: LOGO_HEIGHT)
        .background(Color.white)
        .padding(4)
        .border(.white, width: 4)
    }
}


#Preview("Success") {
    @State @Previewable var movieDetails: MovieDetails? = nil
    let movieRep = MockMovieRepository()
    let imageRep = MockImageRepository()

    Group {
        if let details = movieDetails {
            LogoView(
                details.productionCompanies.first!,
                { company in
                    ImageLocator(imageRep, company.logoPath, .logo)
                }
            )
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
    let appContainer = AppContainer.mocked()

    Group {
        if let details = movieDetails {
            LogoView(
                details.productionCompanies.first!,
                { company in
                    ImageLocator(appContainer.imageRepository, "/does_not_exist", .logo)
                }
            )
        } else {
            ProgressView()
        }
    }
    .preferredColorScheme(.dark)
    .task {
        movieDetails = try! await appContainer.movieRepository.fetchMovieDetails(for: 550)
    }
}
