//
//  ReviewsView.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 8/1/26.
//

import SwiftUI

struct ReviewListView: View {
    
    private let REVIEW_HEIGHT = 120.0
    
    private let feed: ReviewsFeed
    private let onTapReview: (Review) -> Void
    
    
    init(_ feed: ReviewsFeed, _ onTapReview: @escaping (Review) -> Void = { _ in }) {
        
        self.feed = feed
        self.onTapReview = onTapReview
    }
    
    var body: some View {

        LazyCarousel(
            feed: feed,
            content: { review in
                ReviewView(review) {
                        self.onTapReview(review)
                    }
                    .frame(height: REVIEW_HEIGHT)
            },
            placeholder: {
                ProgressView()
                    .frame(height: REVIEW_HEIGHT)
            }
        )
    }
}


#Preview {
    let feed = MockMovieRepository().reviewsFeed(for: 550)
    
    ReviewListView(feed)
        .preferredColorScheme(.dark)
        .onAppear {
            Task {
                await feed.fetchMore()
            }
        }
}

