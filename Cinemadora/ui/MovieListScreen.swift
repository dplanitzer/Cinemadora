//
//  MovieListScreen.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/22/26.
//

import SwiftUI

struct MovieListScreen: View {
    
    @State private var model: MoviesViewModel
    @Namespace private var movieNamespace
    
    
    init(_ model: MoviesViewModel) {
        self.model = model
    }
    
    var body: some View {
        
        NavigationStack {
            
            if model.moviesFeed.items.isEmpty {
                showMovieListPlaceholder()
            }
            else {
                showMovieList()
            }
        }
        .task {
            await model.moviesFeed.fetchMore()
        }
    }

    @ViewBuilder
    private func showMovieListPlaceholder() -> some View {
        
        if model.moviesFeed.isLoading {
            ProgressView {
                Text("Loading...")
            }
        }
        else if !model.moviesFeed.errorDescription.isEmpty {
            Text("Error: \(model.moviesFeed.errorDescription)")
                .foregroundStyle(.red)
                .multilineTextAlignment(.center)
        }
        else if !model.moviesFeed.hasMore {
            Text("No movies")
                .multilineTextAlignment(.center)
        }
    }
    
    @ViewBuilder
    private func showMovieList() -> some View {
        
        let moviesFeed = model.moviesFeed
        
        VStack(spacing: 20) {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(moviesFeed.items) { (movie: Movie) in
                        NavigationLink(value: MovieDetailsTarget(id: movie.id)) {
                            MovieCardView(
                                movie: movie,
                                genres: model.genresFeed(for: movie).items,
                                posterImage: model.posterImage(for: movie)
                            )
                                .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                                .scrollTransition(.interactive, axis: .horizontal) { content, phase in
                                    content
                                        .scaleEffect(phase.isIdentity ? 1.0 : 0.9)
                                        .opacity(phase.isIdentity ? 1.0 : 0.6)
                                }
                                .task {
                                    await model.genresFeed(for: movie).fetchMore()
                                }
                                .onAppear {
                                    if movie.id == moviesFeed.items.last?.id {
                                        Task {
                                            await moviesFeed.fetchMore()
                                        }
                                    }
                                }
                                .matchedTransitionSource(id: movie.id, in: movieNamespace)
                        }
                        .buttonStyle(.plain)
                        
                        if moviesFeed.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            
            
            HStack(spacing: 8) {
                ForEach(0..<3) { idx in
                    Circle()
                        .fill(idx == 1 ? Color.primary.opacity(0.6) : Color.secondary.opacity(0.5))
                        .frame(width: idx == 1 ? 10 : 7, height: idx == 1 ? 10 : 7)
                }
            }
        }
        .navigationDestination(for: MovieDetailsTarget.self) { target in
            MovieDetailsScreen(model.makeDetailsViewModel(for: model.moviesFeed.movie(for: target.id)!), movieNamespace)
        }
    }
}


#Preview {
    MovieListScreen(MoviesViewModel(.popular, AppContainer.mocked()))
        .preferredColorScheme(.dark)
}
