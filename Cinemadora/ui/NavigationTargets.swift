//
//  NavigationTargets.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 8/10/26.
//

import Foundation

protocol NavigationTarget : Hashable {
    
    init(id: Int)
    
    var id: Int { get }
}


struct MovieDetailsTarget: @MainActor NavigationTarget { let id: Int }
struct CastMemberDetailsTarget: @MainActor NavigationTarget { let id: Int }
struct CrewMemberDetailsTarget: @MainActor NavigationTarget { let id: Int }
