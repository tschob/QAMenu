//
//  DialogTrigger.swift
//
//  Created by Hans Seiffert on 19.12.20.
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
import Combine
import QAMenu
import SwiftUI

extension DialogContent {

    public func asAlert() -> Alert? {
        let dismissButton = self.dismissAction?.asAlertButton()
        let primaryButton = self.primaryAction?.asAlertButton()
        let secondaryButton = self.secondaryAction?.asAlertButton()
        if let dismissButton = dismissButton {
            return Alert(
                title: Text(self.title ?? ""),
                message: Text(self.message ?? ""),
                dismissButton: dismissButton
            )
        } else if let primaryButton = primaryButton, let secondaryButton = secondaryButton {
            return Alert(
                title: Text(self.title ?? ""),
                message: Text(self.message ?? ""),
                primaryButton: primaryButton,
                secondaryButton: secondaryButton
            )
        } else {
            return nil
        }
    }
}

extension DialogContent.Action {

    public func asAlertButton() -> Alert.Button? {
        switch buttonType {
        case .cancel:
            return .cancel(Text(self.title)) {
                self.action?()
            }
        case .normal:
            return .default(Text(self.title)) {
                self.action?()
            }
        case .destructive:
            return .destructive(Text(self.title)) {
                self.action?()
            }
        }
    }
}

