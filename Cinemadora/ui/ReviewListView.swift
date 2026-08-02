//
//  ReviewsView.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 8/1/26.
//

import SwiftUI

struct ReviewListView: View {
    
    @State private var model: ReviewsViewModel

    
    init(_ model: ReviewsViewModel) {
        self.model = model
    }
    
    var body: some View {
        
        if !model.reviews.isEmpty {
            showReviewList()
        }
        else {
            showPlaceholder()
            Color.clear.task {
                    await model.fetchMore()
                }
        }
    }

    @ViewBuilder
    private func showPlaceholder() -> some View {

        if model.isLoading {
            ProgressView()
        }
        else if !model.errorDescription.isEmpty {
            Text("Error: \(model.errorDescription)")
                .foregroundStyle(.red)
        }
        else if !model.hasMore {
            Text("No reviews")
        }
    }
    
    @ViewBuilder
    private func showReviewList() -> some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(model.reviews) { review in
                    ReviewView(rating: review.authorDetails.rating, author: review.author, content: review.content)
                        .frame(width: 200, height: 120)
                        .onAppear {
                            if review.id == model.reviews.last?.id {
                                Task {
                                    await model.fetchMore()
                                }
                            }
                        }

                    if model.isLoading {
                        ProgressView()
                            .frame(width: 100, height: 120)
                            .padding()
                    }
                }
            }
            .padding(.horizontal)
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
    }
}


#Preview {
    ReviewListView(ReviewsViewModel(550, MockMovieRepository(), MockImageRepository()))
        .preferredColorScheme(.dark)
}
