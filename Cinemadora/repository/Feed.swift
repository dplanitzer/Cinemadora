//
//  Feed.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 9/3/26.
//

import Foundation

protocol Feed {
    
    associatedtype Item: Identifiable
    
    var items: [Item] { get }
    var isLoading: Bool { get }
    var hasMore: Bool { get }
    
    func fetchMore() async
}
