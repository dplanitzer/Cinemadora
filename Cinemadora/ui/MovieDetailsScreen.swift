//
//  MovieDetailsScreen.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/23/26.
//

import SwiftUI

struct MovieDetailsScreen: View {
    
    private let model: MovieViewModel
    private var namespace: Namespace.ID

    @State private var selectedReview: Review? = nil

    
    init(_ model: MovieViewModel, _ namespace: Namespace.ID) {
        self.model = model
        self.namespace = namespace
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                AsyncImageView(model.posterImage) { state in
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
                
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: max(geometry.size.height * 0.40 - 30, 0))
                    
                    LinearGradient(
                        colors: [.clear, .black],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 30)
                    
                    ScrollView {
                        MovieInfoView(model, onTapReview: { review in
                            withAnimation(.easeInOut(duration: 0.25)) {
                                                        selectedReview = review
                                                    }
                        })
                    }
                    .scrollIndicators(.hidden)
                    .offset(y: -30)
                    .background(.background)
                    .ignoresSafeArea(edges: .bottom)
                }
                
                if let theReview = selectedReview {
                    ReviewOverlayView(theReview) {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                selectedReview = nil
                            }
                        }
                        .transition(.opacity)
                }

            }
            .navigationTransition(.zoom(sourceID: model.id, in: namespace))
        }
    }
}


private struct MovieInfoView: View {
    
    @State private var model: MovieViewModel
    @State private var details: MovieDetailsViewModel
    @State private var credits: CreditsViewModel

    private let onTapReview: (Review) -> Void

    
    init(_ model: MovieViewModel, onTapReview: @escaping (Review) -> Void) {
        self.model = model
        self.onTapReview = onTapReview
        
        self.details = model.makeDetailsViewModel()
        self.credits = model.makeCreditsViewModel()
    }
    
    var body: some View {
        let movie = model.movie
        
        VStack(alignment: .leading, spacing: 28) {
            Text(movie.title)
                .font(.title)
                .bold()
                    
                    
            GenreListView(model.genres)

            
            HStack(spacing: 16) {
                if let voteAvg = movie.voteAverage {
                    RatingView(voteAverage: voteAvg, voteCount: movie.voteCount)
                }
                

                ReleaseYearView(model.releaseYear)

                
                if let runtime = details.details?.runtime {
                    RuntimeView(runtime)
                }
            }

            
            if let director = credits.director {
                HStack(spacing: 8) {
                    Text("Director")
                        .font(.footnote)
                        .bold()
                    
                    Text(director.name)
                        .font(.footnote)
                }
            }

                    
            if let overview = movie.overview, !overview.isEmpty {
                Text(overview)
                    .font(.body)
            }

            
            VStack(alignment: .leading) {
                Text("Cast")
                    .font(.headline)
                    .bold()
                
                CreditsView<CastMemberDetailsTarget>(credits, .cast)
            }
            
            
            VStack(alignment: .leading) {
                Text("Crew")
                    .font(.headline)
                    .bold()
                
                CreditsView<CrewMemberDetailsTarget>(credits, .crew)
            }
            
            
            VStack(alignment: .leading) {
                Text("Reviews")
                    .font(.headline)
                    .bold()
                
                ReviewListView(details.reviewsFeed, onTapReview)
            }
            

            if let companies = details.details?.productionCompanies, !companies.isEmpty {
                VStack(alignment: .leading) {
                    Text("Studio")
                        .font(.headline)
                        .bold()
                    
                    StudioListView(companies, details.image(for:))
                }
            }

            
            if details.details?.budget != nil || details.details?.revenue != nil {
                HStack(spacing: 16) {
                    if let budget = details.details?.budget {
                        HStack(spacing: 8) {
                            Text("Budget")
                                .font(.footnote)
                                .bold()
                            
                            CurrencyView(budget)
                        }
                    }
                    
                    
                    if let revenue = details.details?.revenue {
                        HStack(spacing: 8) {
                            Text("Revenue")
                                .font(.footnote)
                                .bold()
                            
                            CurrencyView(revenue)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 10)
        .task {
            await model.fetchGenres()
            await details.fetchDetails()
        }
    }
}


#Preview {
    @State @Previewable var movieState: Movie? = nil
    let movieRep = MockMovieRepository()

    Group {
        if let movie = movieState {
            PreviewWrapper(MovieViewModel(movie, movieRep, MockImageRepository())) { model, namespace in
                MovieDetailsScreen(model, namespace)
            }
        } else {
            ProgressView()
        }
    }
    .preferredColorScheme(.dark)
    .task {
        movieState = try! await movieRep.fetchMovieListPage(for: .popular, 1).results.first!
    }
}
