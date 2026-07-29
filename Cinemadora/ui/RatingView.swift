//
//  RatingView.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/26/26.
//

import SwiftUI

struct RatingView: View {
    
    private let movie: Movie
    
    
    init(_ movie: Movie) {
        self.movie = movie
    }
    
    var body: some View {
        
        HStack {
            Image(systemName: "star.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 16)
                .foregroundColor(.yellow)
                
            Text("**\(ratingText)/10**  \(votesText) votes")
                .font(.footnote)
                .underline()
        }
    }
    
    private var ratingText: String {
        
        return String(format: "%.1f", movie.voteAverage)
    }
    
    private var votesText: String {
        
        if movie.voteCount < 1000 {
            return String(movie.voteCount)
        }
        else if movie.voteCount < 1000_000 {
            return "\(movie.voteCount / 1000)k"
        }
        else {
            return "\(movie.voteCount / 1000_000)m"
        }
    }
}
