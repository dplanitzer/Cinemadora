//
//  ReleaseYearView.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 8/10/26.
//

import SwiftUI

struct ReleaseYearView: View {
    
    private let year: String
    
    init(_ year: String) {
        
        self.year = year
    }
    
    var body: some View {
        
        HStack(spacing: 4) {
            Image(systemName: "movieclapper")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 14)
                .foregroundColor(.white)
                
            Text(year)
                .font(.footnote)
        }
    }
}


#Preview {
    ReleaseYearView("07-01-2026")
        .preferredColorScheme(.dark)
}
