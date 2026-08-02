//
//  RatingView.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/26/26.
//

import SwiftUI

struct RatingView: View {
    
    private let voteAverage: Double
    private let showVoteMax: Bool
    private let voteCount: Int?
    
    init(voteAverage: Double, showVoteMax: Bool = true, voteCount: Int? = nil) {
        self.voteAverage = voteAverage
        self.showVoteMax = showVoteMax
        self.voteCount = voteCount
    }
    
    var body: some View {
        
        let votesExtra = votesText != nil ? "(\(votesText!) votes)" : ""
        
        HStack {
            Image(systemName: "star.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 14)
                .foregroundColor(.yellow)
                
            Text("**\(ratingText)**  \(votesExtra)")
                .font(.footnote)
        }
    }
    
    private var ratingText: String {
        
        let multiplied = (voteAverage * 10).rounded(.towardZero) / 10
        let isInteger = multiplied.truncatingRemainder(dividingBy: 1) == 0
        let voteAvgTxt: String
        
        if isInteger {
            voteAvgTxt = String(Int(multiplied))
        } else {
            voteAvgTxt = String(format: "%.1f", multiplied)
        }
        
        if showVoteMax {
            return voteAvgTxt + "/10"
        } else {
            return voteAvgTxt
        }
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
