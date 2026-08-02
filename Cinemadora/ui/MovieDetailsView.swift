//
//  MovieDetailsView.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/23/26.
//

import SwiftUI

struct MovieDetailsView: View {
    
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
        
        VStack {
            AsyncImageView(model.posterImage, cornerRadius: 20.0)
                .frame(maxWidth: .infinity)
                .frame(height: 300)

            ScrollView {
                VStack(alignment: .leading) {
                    Text(movie.title)
                        .font(.title)
                        .bold()
                        .padding(.bottom, 18)
                    
                    
                    MovieGenresView(model)
                        .padding(.leading, 10.0)
                        .padding(.bottom, 14)

                    
                    if let voteAvg = movie.voteAverage {
                        RatingView(voteAverage: voteAvg, voteCount: movie.voteCount)
                            .padding(.bottom, 14)
                    }
                    
                    
                    if let releaseDate = movie.releaseDate, !releaseDate.isEmpty {
                        Text("Release Date")
                            .font(.headline)
                            .bold()
                            .padding(.bottom, 4)
                        
                        Text(releaseDate)
                            .font(.body)
                            .padding(.bottom, 14)
                    }

                    
                    if let overview = movie.overview, !overview.isEmpty {
                        Text("Overview")
                            .font(.headline)
                            .bold()
                            .padding(.bottom, 4)
                        
                        Text(overview)
                            .font(.body)
                            .padding(.bottom, 14)
                    }

                    
                    Text("Cast")
                        .font(.headline)
                        .bold()
                        .padding(.bottom, 4)

                    CreditsView(credits, .cast)
                        .padding(.bottom, 14)

                    
                    Text("Crew")
                        .font(.headline)
                        .bold()
                        .padding(.bottom, 4)

                    CreditsView(credits, .crew)
                        .padding(.bottom, 14)

                    
                    Text("Reviews")
                        .font(.headline)
                        .bold()
                        .padding(.bottom, 4)

                    ReviewListView(reviews)
                }
            }
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
