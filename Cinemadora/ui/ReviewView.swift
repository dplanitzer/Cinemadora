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
            HStack {
                if let rating = rating {
                    Image(systemName: "star.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 16)
                        .foregroundColor(.yellow)
                    
                    Text("\(String(format: "%.1f", rating))")
                        .font(.footnote)
                    
                    Text(author)
                }
            }
            
            Text(content)
        }
    }
}


#Preview {
    ReviewView(rating: 9, author: "Foo", content: "Today is a nice day. Who would have thought so. Or maybe it isn't. Could be so too.")
        .preferredColorScheme(.dark)
}
