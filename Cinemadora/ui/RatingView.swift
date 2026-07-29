//
//  RatingView.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/26/26.
//

import SwiftUI

struct RatingView: View {
    
    private let voteAverage: Double
    private let voteCount: Int?
    
    init(voteAverage: Double, voteCount: Int? = nil) {
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }
    
    var body: some View {
        
        HStack {
            Image(systemName: "star.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 16)
                .foregroundColor(.yellow)
                
            if let votesTxt = votesText {
                Text("**\(ratingText)/10**  \(votesTxt) votes")
                    .font(.footnote)
                    .underline()
            } else {
                Text("**\(ratingText)/10**")
                    .font(.footnote)
                    .underline()
            }
        }
    }
    
    private var ratingText: String {
        
        return String(format: "%.1f", voteAverage)
    }
    
    private var votesText: String? {
        
        guard let voteCount = voteCount else { return nil }
        
        if voteCount < 1000 {
            return String(voteCount)
        }
        else if voteCount < 1000_000 {
            return "\(voteCount / 1000)k"
        }
        else {
            return "\(voteCount / 1000_000)m"
        }
    }
}


#Preview {
    RatingView(voteAverage: 0.87, voteCount: 10_345)
        .preferredColorScheme(.dark)
}
