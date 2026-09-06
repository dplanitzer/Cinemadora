//
//  Carousel.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 9/5/26.
//

import SwiftUI

struct Carousel<T: Identifiable, Content: View, Placeholder: View>: View {
    
    private let items: [T]
    
    private let isPaged: Bool
    private let spacing: CGFloat
    private let content: (T) -> Content
    private let placeholder: () -> Placeholder
    
    
    init(items: [T], isPaged: Bool = false, spacing: CGFloat = 8.0, @ViewBuilder content: @escaping (T) -> Content, @ViewBuilder placeholder: @escaping () -> Placeholder) {
        
        self.items = items
        self.isPaged = isPaged
        self.spacing = spacing
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        Group {
            if items.isEmpty {
                placeholder()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: spacing) {
                        ForEach(items) { item in
                            content(item)
                                .if(isPaged) { view in
                                    view.containerRelativeFrame(.horizontal)
                                }
                        }
                    }
                    .scrollTargetLayout()
                }
                .conditionalScrollBehavior(isPaged: isPaged)
            }
        }
    }
}
