//
//  ReviewView.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 8/1/26.
//

import SwiftUI

struct ReviewView: View {
    
    private let rating: Double?
    private let author: String
    private let content: String
    
    init(rating: Double?, author: String, content: String) {
        self.rating = rating
        self.author = author
        self.content = content
    }
    
    var body: some View {
        
        VStack {
            HStack(spacing: 4) {
                if let rating = rating {
                    RatingView(voteAverage: rating, showVoteMax: false)
                }
                
                Text(author)
                    .font(.callout)
                    .bold()
                
                Spacer()
            }
            
            Text(content)
                .font(.subheadline)
        }
    }
}


#Preview {
    ReviewView(rating: 9, author: "Foo", content: "Today is a nice day. Who would have thought so. Or maybe it isn't. Could be so too.")
        .preferredColorScheme(.dark)
}
