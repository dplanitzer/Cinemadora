//
//  GenreView.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/29/26.
//

import SwiftUI

struct GenreView: View {
    
    private let name: String
    
    
    init(_ name: String) {
        self.name = name
    }
    
    var body: some View {
        
        Text(name)
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
        GenreView("Action")
        GenreView("Drama")
        GenreView("Horror")
    }
    .preferredColorScheme(.dark)
}
