//
//  Extensions.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 9/4/26.
//

import SwiftUI

extension View {
    
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    @ViewBuilder
    func conditionalScrollBehavior(isPaged: Bool) -> some View {
        if isPaged {
            self.scrollTargetBehavior(.paging)
        } else {
            self.scrollTargetBehavior(.viewAligned)
        }
    }
}
