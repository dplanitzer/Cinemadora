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


struct AsyncImageView: View {
    
    private let locator: ImageLocator
    private let cornerRadius: CGFloat
    
    @State var state: ImageState = .idle

    
    init(_ locator: ImageLocator, cornerRadius: CGFloat = 0.0) {
        self.locator = locator
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        
        Group {
            switch state {
            case .idle:
                Color.gray.opacity(0.2)
                
            case .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            case .loaded(let image):
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .clipShape(.rect(cornerRadius: cornerRadius))
                
            case .fallback:
                Color.black

            case .failed:
                Color.gray.opacity(0.3)
            }
        }
        .task {
            await fetchImage()
        }
    }
    
    private func fetchImage() async {
        
        guard state == .idle else { return }
        
        if let path = locator.path, !path.isEmpty {
            state = .loading
            
            do {
                state = .loaded(image: try await locator.imageRepository.image(for: path, usage: locator.usage, size: .large))
            } catch {
                state = .failed(error: error.localizedDescription)
            }
        } else {
            state = .fallback
        }
    }
}


#Preview {
    AsyncImageView(ImageLocator(MockImageRepository(), "/5rhTDKUhPYvpdQIijFIs5VoWsON.jpg", .poster))
        .preferredColorScheme(.dark)
}
