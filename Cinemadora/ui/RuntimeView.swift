//
//  RuntimeView.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 8/2/26.
//

import SwiftUI

struct RuntimeView: View {
    
    private let runtime: Int        // In minutes
    
    init(_ runtime: Int) {
        self.runtime = runtime
    }
    
    var body: some View {
        
        HStack(spacing: 4) {
            Image(systemName: "clock")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 14)
                .foregroundColor(.white)
                
            Text(runtimeText)
                .font(.footnote)
        }
    }
    
    private var runtimeText: String {
        
        let h = runtime / 60
        let min = runtime - h * 60
        
        if h == 0 {
            return "\(min)min"
        } else if min == 0 {
            return "\(h)h"
        } else {
            return "\(h)h \(min)min"
        }
    }
}


#Preview {
    RuntimeView(15)
        .preferredColorScheme(.dark)

    RuntimeView(120)
        .preferredColorScheme(.dark)

    RuntimeView(134)
        .preferredColorScheme(.dark)
}
