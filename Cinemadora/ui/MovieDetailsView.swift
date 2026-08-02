//
//  MovieDetailsView.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/23/26.
//

import SwiftUI

struct MovieDetailsView: View {
    
    private let model: MovieViewModel

    
    init(_ model: MovieViewModel) {
        self.model = model
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                AsyncImageView(model.posterImage, cornerRadius: 0.0)
                    .frame(maxWidth: .infinity)
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
                        MovieInfoView(model)
                    }
                    .scrollIndicators(.hidden)
                    .offset(y: -30)
                    .background(.background)
                    .ignoresSafeArea(edges: .bottom)
                }
            }
        }
    }
}


private struct MovieInfoView: View {
    
    @State private var model: MovieViewModel
    @State private var details: MovieDetailsViewModel
    @State private var credits: CreditsViewModel
    @State private var reviews: ReviewsViewModel

    
    init(_ model: MovieViewModel) {
        self.model = model
        self.details = model.makeDetailsViewModel()
        self.credits = model.makeCreditsViewModel()
        self.reviews = model.makeReviewsViewModel()
    }
    
    var body: some View {
        let movie = model.movie
        
        VStack(alignment: .leading, spacing: 28) {
            Text(movie.title)
                .font(.title)
                .bold()
                    
                    
            MovieGenresView(model)

            
            HStack(spacing: 16) {
                if let voteAvg = movie.voteAverage {
                    RatingView(voteAverage: voteAvg, voteCount: movie.voteCount)
                }
                
                
                if let runtime = details.details?.runtime {
                    RuntimeView(runtime)
                }
            }

            
            if let releaseDate = movie.releaseDate, !releaseDate.isEmpty {
                HStack(spacing: 4) {
                    Text("Release Date")
                        .font(.footnote)
                        .bold()
                    
                    Text(releaseDate)
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
                
                CreditsView(credits, .cast)
            }
            
            
            VStack(alignment: .leading) {
                Text("Crew")
                    .font(.headline)
                    .bold()
                
                CreditsView(credits, .crew)
            }
            
            
            VStack(alignment: .leading) {
                Text("Reviews")
                    .font(.headline)
                    .bold()
                
                ReviewListView(reviews)
            }
        }
        .task {
            await details.fetchDetails()
        }
    }
}


#Preview {
    @State @Previewable var movieState: Movie? = nil
    let movieRep = MockMovieRepository()

    Group {
        if let movie = movieState {
            MovieDetailsView(MovieViewModel(movie, movieRep, MockImageRepository()))
        } else {
            ProgressView()
        }
    }
    .preferredColorScheme(.dark)
    .task {
        movieState = try! await movieRep.fetchMovieListPage(for: .popular, 1).results.first!
    }
}
