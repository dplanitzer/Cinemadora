//
//  Carousel.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 9/5/26.
//

import SwiftUI

struct Carousel<Element, Content: View, Placeholder: View>: View {
    
    private struct IdentifiedItem: Identifiable {
        let id: AnyHashable
        let value: Element
    }
    
    
    private let items: [IdentifiedItem]
    
    private let isPaged: Bool
    private let spacing: CGFloat
    private let content: (Element) -> Content
    private let placeholder: () -> Placeholder
    
    
    init(items: [Element],
         id: @escaping (Element) -> some Hashable,
         isPaged: Bool = false,
         spacing: CGFloat = 8.0,
         @ViewBuilder content: @escaping (Element) -> Content,
         @ViewBuilder placeholder: @escaping () -> Placeholder = { EmptyView() }
    ) {
        
        self.items = items.map { IdentifiedItem(id: AnyHashable(id($0)), value: $0) }
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
                        ForEach(items) { (item: IdentifiedItem) in
                            content(item.value)
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


extension Carousel where Element: Identifiable {
    
    init(
        items: [Element],
        isPaged: Bool = false,
        spacing: CGFloat = 8.0,
        @ViewBuilder content: @escaping (Element) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder = { EmptyView() }
    ) {
        
        self.init(
            items: items,
            id: { $0.id },
            isPaged: isPaged,
            spacing: spacing,
            content: content,
            placeholder: placeholder
        )
    }
}
