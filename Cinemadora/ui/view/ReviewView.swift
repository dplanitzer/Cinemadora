//
//  ReviewView.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 8/1/26.
//

import SwiftUI

struct ReviewView: View {
    
    private let review: Review
    private let onTap: () -> Void
    
    
    init(_ review: Review, _ onTap: @escaping () -> Void = {}) {
        
        self.review = review
        self.onTap = onTap
    }
    
    var body: some View {
        
        ZStack {
            VStack {
                HStack(spacing: 4) {
                    if let rating = review.authorDetails.rating {
                        RatingView(voteAverage: rating, showVoteMax: false)
                    }
                    
                    Text(review.author)
                        .font(.callout)
                        .bold()
                    
                    Spacer()
                }
                
                Text(review.content)
                    .font(.subheadline)
            }
        }
        .onTapGesture(perform: onTap)
    }
}


#Preview {
    @State @Previewable var reviewState: Review? = nil
    let appContainer = AppContainer.mocked()

    Group {
        if let review = reviewState {
            ReviewView(review)
        } else {
            ProgressView()
        }
    }
    .preferredColorScheme(.dark)
    .task {
        reviewState = try! await appContainer.reviewRepository.fetchReviewsListPage(for: 550, 1).results[1]
    }
}

