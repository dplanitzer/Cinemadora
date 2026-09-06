//
//  GenreView.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/29/26.
//

import SwiftUI

struct GenreView: View {
    
    private let genre: Genre
    
    
    init(_ genre: Genre) {
        
        self.genre = genre
    }
    
    var body: some View {
        
        Text(genre.name)
            .font(.footnote)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .overlay(
                Capsule()
                    .stroke(Color.white.opacity(0.45), lineWidth: 1.5)
            )
    }
}


#Preview {
    HStack(spacing: 10) {
        GenreView(Genre(id: 1, name: "Action"))
        GenreView(Genre(id: 2, name: "Drama"))
        GenreView(Genre(id: 3, name: "Horror"))
    }
    .preferredColorScheme(.dark)
}
