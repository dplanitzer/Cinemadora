//
//  CurrencyView.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 8/8/26.
//

import SwiftUI

struct CurrencyView: View {
    
    private let value: Int
    
    init(_ value: Int) {
        
        self.value = value
    }
    
    var body: some View {
        
        Text("$\(formattedCurrency)")
            .font(.footnote)
    }
    
    private var formattedCurrency: String {
        
        let scaledValue: Double
        let scale: String
        
        if value < 1000 {
            scaledValue = Double(value)
            scale = ""
        }
        else if value < 1000_000 {
            scaledValue = Double(value) / 1000
            scale = "K"
        }
        else if value < 1000_000_000 {
            scaledValue = Double(value) / 1000_000
            scale = "M"
        }
        else {
            scaledValue = Double(value) / 1000_000_000
            scale = "B"
        }
        
        
        let multiplied = (scaledValue * 10).rounded(.towardZero) / 10
        let isInteger = multiplied.truncatingRemainder(dividingBy: 1) == 0
        let text: String
        
        if isInteger {
            text = String(Int(multiplied))
        } else {
            text = String(format: "%.1f", multiplied)
        }
        
        return text + scale
    }
}


#Preview {
    CurrencyView(4000)
        .preferredColorScheme(.dark)

    CurrencyView(8990)
        .preferredColorScheme(.dark)
    
    CurrencyView(899_333)
        .preferredColorScheme(.dark)
    
    CurrencyView(899_333_555)
        .preferredColorScheme(.dark)
    
    CurrencyView(899_333_555_111)
        .preferredColorScheme(.dark)
}
