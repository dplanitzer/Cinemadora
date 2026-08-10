//
//  PreviewWrapper.swift
//  Cinemadora
//
//  Created by Dietmar Planitzer on 8/10/26.
//

import SwiftUI

struct PreviewWrapper<ViewModel, Content: View>: View {
    
    private let model: ViewModel
    private let viewBuilder: (ViewModel, Namespace.ID) -> Content
    @Namespace private var previewNamespace
    
    init(_ model: ViewModel, @ViewBuilder _ viewBuilder: @escaping (ViewModel, Namespace.ID) -> Content) {
        self.model = model
        self.viewBuilder = viewBuilder
    }
    
    var body: some View {
        viewBuilder(model, previewNamespace)
    }
}
