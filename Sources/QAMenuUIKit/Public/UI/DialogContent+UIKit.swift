//
//  DialogContent+UIKit.swift
//
//  Created by Hans Seiffert on 02.04.22.
//
//  ---
//  MIT License
//
//  Copyright © 2022 Hans Seiffert
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

// MARK: - DialogContent

extension DialogContent {

    public func asUIAlertController() -> UIAlertController? {
        let dismissAction = self.dismissAction?.asUIAlertAction()
        let primaryAction = self.primaryAction?.asUIAlertAction()
        let secondaryAction = self.secondaryAction?.asUIAlertAction()

        let alert = UIAlertController(
            title: self.title,
            message: self.message,
            preferredStyle: .alert
        )

        if let dismissAction = dismissAction {
            alert.addAction(dismissAction)
        } else if let primaryAction = primaryAction, let secondaryAction = secondaryAction {
            alert.addAction(primaryAction)
            alert.addAction(secondaryAction)
        } else {
            return nil
        }
        return alert
    }
}

// MARK: - DialogContent.Action

extension DialogContent.Action {

    public func asUIAlertAction() -> UIAlertAction? {
        switch buttonType {
        case .cancel:
            return UIAlertAction(title: self.title, style: .cancel) { _ in
                self.action?()
            }
        case .normal:
            return UIAlertAction(title: self.title, style: .default) { _ in
                self.action?()
            }
        case .destructive:
            return UIAlertAction(title: self.title, style: .destructive) { _ in
                self.action?()
            }
        }
    }
}
