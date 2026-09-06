//
//  LazyCarousel.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 9/3/26.
//

import SwiftUI

struct LazyCarousel<T: Feed, Content: View, Placeholder: View>: View {
    
    @State var feed: T
    
    private let isPaged: Bool
    private let spacing: CGFloat
    private let content: (T.Item) -> Content
    private let placeholder: () -> Placeholder
    
    
    init(feed: T, isPaged: Bool = true, spacing: CGFloat = 8.0, @ViewBuilder content: @escaping (T.Item) -> Content, @ViewBuilder placeholder: @escaping () -> Placeholder) {
        
        self.feed = feed
        self.isPaged = isPaged
        self.spacing = spacing
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        Group {
            if feed.items.isEmpty && feed.isLoading {
                placeholder()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: self.spacing) {
                        ForEach(feed.items) { item in
                            content(item)
                                .if(self.isPaged) { view in
                                    view.containerRelativeFrame(.horizontal)
                                }
                                .onAppear {
                                    if item.id == feed.items.last?.id && feed.hasMore {
                                        Task {
                                            await feed.fetchMore()
                                        }
                                    }
                                }
                        }

                        
                        // Render a placeholder at the end of teh list if more data is available
                        if !feed.items.isEmpty && feed.isLoading {
                            placeholder()
                        }
                    }
                    .scrollTargetLayout()
                }
                .conditionalScrollBehavior(isPaged: self.isPaged)
            }
        }
    }
}
