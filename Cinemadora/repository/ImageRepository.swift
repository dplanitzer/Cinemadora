//
//  ImageRepository.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/26/26.
//

import SwiftUI

nonisolated enum ImageSizeClass {
    case small
    case middle
    case large
    case original
}

nonisolated enum ImageUsage {
    case backdrop
    case poster
    case logo
    case profile
    case still
}


protocol ImageRepository {
    
    func image(for basePath: String, usage: ImageUsage, size: ImageSizeClass) async throws -> UIImage
}
