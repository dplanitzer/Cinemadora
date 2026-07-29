//
//  ImageRepository.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/26/26.
//

import SwiftUI

enum ImageSizeClass {
    case small
    case middle
    case large
    case original
}

enum ImageUsage {
    case backdrop
    case poster
    case logo
}


protocol ImageRepository {
    
    func image(for basePath: String, usage: ImageUsage, size: ImageSizeClass) async throws -> UIImage
}
