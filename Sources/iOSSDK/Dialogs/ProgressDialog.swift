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
    
    @Binding var startAnimating: Bool
    
    public func makeUIView(context: Context) -> UIActivityIndicatorView {
        return UIActivityIndicatorView()
    }

    public func updateUIView(_ uiView: UIActivityIndicatorView,
                      context: Context) {
        if self.startAnimating {
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
        }
    }
}
