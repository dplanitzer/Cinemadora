//
//  ReviewOverlayView.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 8/10/26.
//

import SwiftUI

struct ReviewOverlayView: View {
    
    private let review: Review
    private let onClose: () -> Void
    
    
    init(_ review: Review, _ onClose: @escaping () -> Void = {}) {
        self.review = review
        self.onClose = onClose
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Dimmed backdrop background
                Color.black.opacity(0.35)
                    .ignoresSafeArea()
                    .onTapGesture(perform: onClose)
                
                
                // Review content
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 4) {
                        if let rating = review.authorDetails.rating {
                            RatingView(voteAverage: rating, showVoteMax: false)
                        }
                        
                        Text(review.author)
                            .font(.title2)
                            .bold()
                        
                        Spacer()
                        
                        Button("Close", action: onClose)
                    }
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            Text(review.content)
                                .font(.body)
                            
                            if let date = try? Date(review.createdAt, strategy: .iso8601) {
                                Text("**Written** \(date.formatted(date: .long, time: .shortened))")
                                    .font(.footnote)
                            }
                        }
                    }
                }
                .padding(20)
                .frame(maxWidth: .infinity)
                .frame(height: geo.size.height * 0.86)
                .background(Color(white: 0.20))
                .cornerRadius(12)
                .shadow(radius: 10)
                .padding(.horizontal, 24)
            }
        }
    }
}


#Preview {
    @State @Previewable var reviewState: Review? = nil
    let movieRep = MockMovieRepository()

    Group {
        if let review = reviewState {
            ReviewOverlayView(review)
        } else {
            ProgressView()
        }
    }
    .preferredColorScheme(.dark)
    .task {
        reviewState = try! await movieRep.fetchReviewsListPage(for: 550, 1).results[1]
    }
}
