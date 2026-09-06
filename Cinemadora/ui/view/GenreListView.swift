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
        
        if !genres.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(genres, id: \.self) { genre in
                        GenreView(genre)
                    }
                }
            }
        } else {
            // Show an effectively invisible dummy genre so that we can keep the
            // height of this UI element stable no matter whether the genres have
            // already been loaded or not
            GenreView("Invisible")
                .opacity(0.0)
        }
    }
}


#Preview {
    VStack {
        Divider()
            .frame(height: 2)
            .overlay(Color.white)
        
        GenreListView(["Action", "Drama", "Horror"])
        
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
