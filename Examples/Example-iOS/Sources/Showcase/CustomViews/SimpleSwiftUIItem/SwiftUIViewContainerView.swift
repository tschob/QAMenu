//
//  SwiftUIViewContainerView.swift
//
//  Created by Hans Seiffert on 22.05.21.
//
//  ---
//  MIT License
//
//  Copyright © 2021 Hans Seiffert
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// 

import UIKit
import QAMenu
import QAMenuUIKit

#if canImport(SwiftUI)
  import SwiftUI
#endif

class SwiftUIViewContainerView: UIView, ItemUIRepresentable {

    weak var delegate: ItemUIRepresentableDelegate?

    private var hostingController: UIViewController?

    weak var item: Item? {
        didSet {
            guard let item = item else {
                return
            }
            if #available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *) {
                if hostingController == nil {
                    guard let swiftUIView = SimpleSwiftUIItemView(item: item) else {
                        return
                    }
                    let hostingController = UIHostingController(rootView: swiftUIView)
                    self.hostingController = hostingController
                    delegate?.presentationContext.addChild(hostingController)
                    addSubview(hostingController.view)

                    hostingController.view.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        self.safeAreaLayoutGuide.topAnchor.constraint(equalTo: hostingController.view.topAnchor),
                        self.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: hostingController.view.bottomAnchor),
                        self.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: hostingController.view.leadingAnchor),
                        self.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: hostingController.view.trailingAnchor)
                    ])
                    hostingController.didMove(toParent: nil)
                    hostingController.view.layoutIfNeeded()
                }
            }
        }
    }

    // MARK: - Methods

    func prepareForReuse() {
        hostingController?.view.removeFromSuperview()
        hostingController?.didMove(toParent: nil)
        hostingController = nil
    }

    func setItem(_ item: Item) {
        self.item = item
    }
}
