//
//  ProgressDialog.swift
//  Progress Dialog
//
//  Created by fukoapps on 30.04.2015.
//  Copyright (c) 2015 FukoApps.com. All rights reserved.
//

import UIKit
import QuartzCore
import SwiftUI

public struct ProgressIndicator: UIViewRepresentable {

    @Binding public var isAnimating: Bool
    public let style: UIActivityIndicatorView.Style

    public init(isAnimating: Binding<Bool>,style: UIActivityIndicatorView.Style) {
        self._isAnimating = isAnimating
        self.style = style
    }
    
    public func makeUIView(context: UIViewRepresentableContext<ProgressIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    public func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ProgressIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
