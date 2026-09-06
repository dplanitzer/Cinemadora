//
//  GenreListView.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/29/26.
//

import SwiftUI

struct GenreListView: View {
    
    private let genres: [Genre]
    
    
    init(_ genres: [Genre]) {
        
        self.genres = genres
    }
    
    var body: some View {
        
        #if true
        Carousel(
            items: genres,
            spacing: 8.0,
            content: { genre in
                GenreView(genre)
            },
            placeholder: {
                // Show an effectively invisible dummy genre so that we can keep the
                // height of this UI element stable no matter whether the genres have
                // already been loaded or not
                GenreView(Genre(id: 1, name: "Invisible"))
                    .opacity(0.0)
            }
        )
        .fixedSize(horizontal: false, vertical: true)
#else
        if !genres.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(genres) { genre in
                        GenreView(genre)
                    }
                }
            }
        } else {
            // Show an effectively invisible dummy genre so that we can keep the
            // height of this UI element stable no matter whether the genres have
            // already been loaded or not
            GenreView(Genre(id: 1, name: "Invisible"))
                .opacity(0.0)
        }
        #endif
    }
}


#Preview {
    VStack {
        Divider()
            .frame(height: 2)
            .overlay(Color.white)
        
        GenreListView([Genre(id: 1, name: "Action"), Genre(id: 2, name: "Drama"), Genre(id: 3, name: "Horror")])
        
        Divider()
            .frame(height: 2)
            .overlay(Color.white)

        GenreListView([])
        
        Divider()
            .frame(height: 2)
            .overlay(Color.white)
    }
    .preferredColorScheme(.dark)
}
