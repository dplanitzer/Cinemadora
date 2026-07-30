//
//  GenreListView.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/29/26.
//

import SwiftUI

struct GenreListView: View {
    
    private let genres: [String]
    
    
    init(_ genres: [String]) {
        self.genres = genres
    }
    
    var body: some View {
        
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                ForEach(genres, id: \.self) { genre in
                    GenreView(genre)
                }
                
                Spacer()
            }
        }
        .scrollIndicators(.hidden)
    }
}


#Preview {
    GenreListView(["Action", "Drama", "Horror"])
    .preferredColorScheme(.dark)
}
