//
//  ShareInteractionHandler.swift
//
//  Created by Hans Seiffert on 20.05.20.
//
//  ---
//  MIT License
//
//  Copyright © 2020 Hans Seiffert
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

import Foundation
import UIKit
import QAMenu

internal final class ShareInteractionHandler: ShareInteractionHandling {

    // MARK: - Properties (Internal)

    internal weak var shareable: Shareable?

    // MARK: - Properties (Private)

    private weak var view: UIView?

    private var present: ((_ presentationContext: UIViewController) -> Void) -> Void

    private var gestureRecognizer: UILongPressGestureRecognizer?

    // MARK: - Initialization

    internal required init(
        shareable: Shareable?,
        view: UIView,
        present: @escaping ((_ presentationContext: UIViewController) -> Void) -> Void
    ) {
        self.shareable = shareable
        self.view = view
        self.present = present

        self.addGesture(to: view)
    }

    // MARK: - Methods

    private func addGesture(to view: UIView) {
        let gestureRecognizer = UILongPressGestureRecognizer(
            target: self,
            action: #selector(handleGesture(gestureRecognizer:))
        )
        self.gestureRecognizer = gestureRecognizer
        view.addGestureRecognizer(gestureRecognizer)
    }

    @objc private func handleGesture(gestureRecognizer: UILongPressGestureRecognizer) {
        // Only perform the sharing once per gesture detection
        guard gestureRecognizer.state == .began else {
            return
        }
        self.share()
    }

    internal func share() {
        // Only perform the sharing if sharing is enabled and there is share content
        guard
            let shareable = self.shareable,
            shareable.isSharingEnabled,
            let content = shareable.shareContent else {
                return
        }
        // Create the share sheet
        let activityController = UIActivityViewController(
            activityItems: [content],
            applicationActivities: nil
        )
        activityController.popoverPresentationController?.sourceView = self.view
        // Present the share sheet on the given presentation context
        self.present { (presentationContext: UIViewController) in
            presentationContext.present(activityController, animated: true)
        }
    }
}
