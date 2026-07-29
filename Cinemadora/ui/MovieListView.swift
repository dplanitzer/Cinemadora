//
//  MovieListView.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/22/26.
//

import SwiftUI

struct MovieListView: View {
    
    @State private var model: MovieListViewModel

    
    init(_ model: MovieListViewModel) {
        self.model = model
    }
    
    var body: some View {
        
        NavigationStack {
            
            if model.movies.isEmpty {
                showMovieListPlaceholder()
            }
            else {
                showMovieList()
            }
        }
        .task {
            await model.fetchMore()
        }
    }

    @ViewBuilder
    private func showMovieListPlaceholder() -> some View {
        
        if model.isLoading {
            ProgressView {
                Text("Loading...")
            }
        }
        else if !model.errorDescription.isEmpty {
            Text("Error: \(model.errorDescription)")
                .foregroundStyle(.red)
        }
        else if !model.hasMore {
            Text("No movies")
        }
    }
    
    @ViewBuilder
    private func showMovieList() -> some View {
        
        VStack(spacing: 20) {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(model.movies) { movie in
                        NavigationLink(value: movie) {
                            MovieCardView(model.makeMovieViewModel(for: movie))
                                .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                                .scrollTransition(.interactive, axis: .horizontal) { content, phase in
                                    content
                                        .scaleEffect(phase.isIdentity ? 1.0 : 0.9)
                                        .opacity(phase.isIdentity ? 1.0 : 0.6)
                                }
                                .onAppear {
                                    if movie == model.movies.last {
                                        Task {
                                            await model.fetchMore()
                                        }
                                    }
                                }
                        }
                        
                        if model.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                    }
                }
                .scrollTargetLayout()
                .navigationDestination(for: Movie.self) { movie in
                    MovieDetailsView(model.makeMovieViewModel(for: movie))
                }
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
    }
}


#Preview {
    let model = MovieListViewModel(.popular, MockMovieRepository(), MockImageRepository())
    
    MovieListView(model)
        .preferredColorScheme(.dark)
}
