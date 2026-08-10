//
//  ReviewsView.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 8/1/26.
//

import SwiftUI

struct ReviewListView: View {
    
    private let REVIEW_HEIGHT = 120.0
    
    @State private var model: ReviewsViewModel
    private let onTapReview: (Review) -> Void
    
    
    init(_ model: ReviewsViewModel, _ onTapReview: @escaping (Review) -> Void) {
        self.model = model
        self.onTapReview = onTapReview
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
                .frame(maxWidth: .infinity)
                .frame(height: REVIEW_HEIGHT)
        }
        else if !model.errorDescription.isEmpty {
            Text("Error: \(model.errorDescription)")
                .frame(maxWidth: .infinity)
                .frame(height: REVIEW_HEIGHT)
                .foregroundStyle(.red)
                .multilineTextAlignment(.center)
        }
        else if !model.hasMore {
            Text("No reviews")
                .frame(maxWidth: .infinity)
                .frame(height: REVIEW_HEIGHT)
                .multilineTextAlignment(.center)
        }
    }
    
    @ViewBuilder
    private func showReviewList() -> some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 0) {
                ForEach(model.reviews) { review in
                        
                    ReviewView(review) {
                            self.onTapReview(review)
                        }
                        .containerRelativeFrame(.horizontal)
                        .frame(height: REVIEW_HEIGHT)
                        .onAppear {
                            if review.id == model.reviews.last?.id {
                                Task {
                                    await model.fetchMore()
                                }
                            }
                        }
                }
                    
                if model.isLoading {
                    ProgressView()
                        .containerRelativeFrame(.horizontal)
                        .frame(height: REVIEW_HEIGHT)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
    }
}

/*
#Preview {
    ReviewListView(ReviewsViewModel(550, MockMovieRepository(), MockImageRepository()))
        .preferredColorScheme(.dark)
}
*/
