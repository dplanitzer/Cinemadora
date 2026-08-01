//
//  ImageLocator.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/31/26.
//

import Foundation

struct ImageLocator {
    let imageRepository: ImageRepository
    let path: String?
    let usage: ImageUsage
    
    init(_ imageRep: ImageRepository, _ path: String?, _ usage: ImageUsage) {
        self.imageRepository = imageRep
        self.path = path
        self.usage = usage
    }
}
