//
//  MovieDetailsScreen.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/23/26.
//

import SwiftUI

struct MovieDetailsScreen: View {
    
    private let model: MovieDetailsViewModel
    private var namespace: Namespace.ID

    @State private var selectedReview: Review? = nil

    
    init(_ model: MovieDetailsViewModel, _ namespace: Namespace.ID) {
        
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
            .navigationTransition(.zoom(sourceID: model.movie.id, in: namespace))
        }
    }
}


private struct MovieInfoView: View {
    
    private let REVIEW_HEIGHT = 120.0

    @State private var model: MovieDetailsViewModel

    @Namespace private var castNamespace
    @Namespace private var crewNamespace

    private let onTapReview: (Review) -> Void

    
    init(_ model: MovieDetailsViewModel, onTapReview: @escaping (Review) -> Void) {
        
        self.model = model
        self.onTapReview = onTapReview
    }
    
    var body: some View {
        let movie = model.movie
        
        VStack(alignment: .leading, spacing: 28) {
            Text(movie.title)
                .font(.title)
                .bold()
                    
            
            Carousel(
                items: model.genresFeed.items,
                spacing: 8.0,
                content: { genre in
                    GenreView(genre)
                },
                placeholder: {
                    // Show an effectively invisible dummy genre so that we can keep the
                    // height of this UI element stable no matter whether the genres have
                    // already been loaded or not
                    GenreView.invisiblePlaceholder()
                }
            )
            .fixedSize(horizontal: false, vertical: true)

            
            HStack(spacing: 16) {
                if let voteAvg = movie.voteAverage {
                    RatingView(voteAverage: voteAvg, voteCount: movie.voteCount)
                }
                

                ReleaseYearView(model.releaseYear)

                
                if let runtime = model.details?.runtime {
                    RuntimeView(runtime)
                }
            }

            
            if let director = model.director {
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
                
                Carousel(
                    items: model.cast,
                    spacing: 16.0,
                    content: { (member: CastMember) in
                        NavigationLink(value: CastMemberDetailsTarget(id: member.id)) {
                            ProfileView(member, model.image(for:))
                                .matchedTransitionSource(id: member.id, in: castNamespace)
                        }
                        .buttonStyle(.plain)
                    }
                )
                .fixedSize(horizontal: false, vertical: true)
            }
            
            
            VStack(alignment: .leading) {
                Text("Crew")
                    .font(.headline)
                    .bold()

                Carousel(
                    items: model.crew,
                    spacing: 16.0,
                    content: { (member: CrewMember) in
                        NavigationLink(value: CrewMemberDetailsTarget(id: member.id)) {
                            ProfileView(member, model.image(for:))
                                .matchedTransitionSource(id: member.id, in: crewNamespace)
                        }
                        .buttonStyle(.plain)
                    }
                )
                .fixedSize(horizontal: false, vertical: true)
            }
            
            
            VStack(alignment: .leading) {
                Text("Reviews")
                    .font(.headline)
                    .bold()
                
                LazyCarousel(
                    feed: model.reviewsFeed,
                    content: { review in
                        ReviewView(review) {
                                self.onTapReview(review)
                            }
                            .frame(height: REVIEW_HEIGHT)
                    },
                    placeholder: {
                        ProgressView()
                            .frame(maxWidth: .infinity, minHeight: REVIEW_HEIGHT)
                    }
                )
            }
            

            if !model.productionCompanies.isEmpty {
                VStack(alignment: .leading) {
                    Text("Studio")
                        .font(.headline)
                        .bold()
                    
                    Carousel(
                        items: model.productionCompanies,
                        spacing: 16.0,
                        content: { company in
                            LogoView(company, model.image(for:))
                        }
                    )
                    .fixedSize(horizontal: false, vertical: true)
                }
            }

            
            if model.details?.budget != nil || model.details?.revenue != nil {
                HStack(spacing: 16) {
                    if let budget = model.details?.budget {
                        HStack(spacing: 8) {
                            Text("Budget")
                                .font(.footnote)
                                .bold()
                            
                            CurrencyView(budget)
                        }
                    }
                    
                    
                    if let revenue = model.details?.revenue {
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
        .navigationDestination(for: CastMemberDetailsTarget.self) { target in
            PersonDetailsScreen(model.makePersonDetailsViewModel(for: target.id), castNamespace)
        }
        .navigationDestination(for: CrewMemberDetailsTarget.self) { target in
            PersonDetailsScreen(model.makePersonDetailsViewModel(for: target.id), crewNamespace)
        }
        .task {
            await model.fetchDetails()
            await model.genresFeed.fetchMore()
        }
    }
}


#Preview {
    @State @Previewable var mvm = MoviesViewModel(.popular, AppContainer.mocked())

    VStack {
        if let movie = mvm.moviesFeed.items.first {
            PreviewWrapper(mvm.makeDetailsViewModel(for: movie)) { model, namespace in
                MovieDetailsScreen(model, namespace)
            }
        } else {
            ProgressView()
        }
    }
    .preferredColorScheme(.dark)
    .task {
        await mvm.moviesFeed.fetchMore()
        
        if let movie = mvm.moviesFeed.items.first {
            await mvm.genresFeed(for: movie).fetchMore()
        }
    }
}
