//
//  AsyncImageView.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 7/31/26.
//

import SwiftUI

enum ImageState : Equatable {
    case idle
    case loading
    case loaded(image: UIImage)     // loaded the origina image successfully, show it
    case fallback                   // no original image was specified (url == null), show a fallback instead
    case failed(error: String)      // loading the origina image failed, show a broken image indicator or a fallback
}


struct AsyncImageView<Content: View>: View {
    
    private let locator: ImageLocator
    private let sizeClass: ImageSizeClass
    private let content: (ImageState) -> Content
    @State private var state: ImageState = .idle

    
    init(_ locator: ImageLocator, size: ImageSizeClass = .large, @ViewBuilder _ content: @escaping (ImageState) -> Content) {
        self.locator = locator
        self.sizeClass = size
        self.content = content
    }
    
    var body: some View {
        
        content(state)
            .task {
                await fetchImage()
            }
    }
    
    private func fetchImage() async {
        
        guard state == .idle else { return }
        
        if let path = locator.path, !path.isEmpty {
            state = .loading
            
            do {
                state = .loaded(image: try await locator.imageRepository.image(for: path, usage: locator.usage, size: sizeClass))
            } catch {
                state = .failed(error: error.localizedDescription)
            }
        } else {
            state = .fallback
        }
    }
}


@ViewBuilder
private func sharedContent(state: ImageState) -> some View {
    switch state {
    case .loading:
        Color(white: 0.22)
            .overlay {
                ProgressView()
                    .tint(.white)
            }

    case .loaded(let image):
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
                    
    case .failed:
        ZStack {
            Color(white: 0.22)
            Image(systemName: "photo.badge.exclamationmark")
                .resizable()
                .scaledToFit()
                .frame(width: 62, height: 62)
                .foregroundColor(.white)
        }
    
    default:
        Color(white: 0.22)
    }
}

#Preview("Success") {
    AsyncImageView(ImageLocator(MockImageRepository(), "/5rhTDKUhPYvpdQIijFIs5VoWsON.jpg", .poster), sharedContent)
        .preferredColorScheme(.dark)
        .frame(maxWidth: .infinity)
        .aspectRatio(0.66, contentMode: .fit)
        .clipShape(.rect(cornerRadius: 60.0))
}

#Preview("Failure") {
    AsyncImageView(ImageLocator(MockImageRepository(), "/not_valid_url", .poster), sharedContent)
        .preferredColorScheme(.dark)
        .frame(maxWidth: .infinity)
        .aspectRatio(0.66, contentMode: .fit)
        .clipShape(.rect(cornerRadius: 60.0))
}
