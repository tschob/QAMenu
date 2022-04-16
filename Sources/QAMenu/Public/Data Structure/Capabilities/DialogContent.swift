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

public struct DialogContent {

    // MARK: - Action

    public struct Action {

        public enum ButtonType {
            case destructive
            case cancel
            case normal
        }
        public let title: String
        public let action: (() -> Void)?
        public let buttonType: ButtonType

        public init(
            title: String,
            action: (() -> Void)? = nil,
            buttonType: ButtonType = .cancel
        ) {
            self.title = title
            self.action = action
            self.buttonType = buttonType
        }
    }

    // MARK: - Properties

    public let title: String?
    public let message: String?
    public let dismissAction: Action?
    public let primaryAction: Action?
    public let secondaryAction: Action?

    // MARK: - Initialization

    public init(
        title: String? = nil,
        message: String? = nil,
        closeButtonTitle: String = "Ok"
    ) {
        self.init(
            title: title,
            message: message,
            dismissAction: Action(title: closeButtonTitle, action: nil, buttonType: .cancel)
        )
    }

    public init(
        title: String? = nil,
        message: String? = nil,
        dismissAction: Action
    ) {
        self.title = title
        self.message = message
        self.dismissAction = dismissAction
        self.primaryAction = nil
        self.secondaryAction = nil
    }

    public init(
        title: String? = nil,
        message: String? = nil,
        primaryAction: Action,
        secondaryAction: Action
    ) {
        self.title = title
        self.message = message
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        self.dismissAction = nil
    }
}
