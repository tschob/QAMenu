//
//  SingleLineTextEditorControllerMock.swift
//
//  Created by Hans Seiffert on 13.02.21.
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
@testable import QAMenuUIKit

internal final class AlertControllerMock: UIAlertController {}

internal final class SingleLineTextEditorControllerMock: SingleLineTextEditorControllerProtocol {

    internal var _dismissCallCount = 0

    internal let onCancelEditing: (_ editor: SingleLineTextEditorControllerProtocol) -> Void
    internal let onEndEditing: (_ newValue: String?, _ editor: SingleLineTextEditorControllerProtocol) -> Void

    internal var viewController: UIViewController = AlertControllerMock()

    internal init(
        title: String?,
        text: String?,
        onCancelEditing: @escaping (SingleLineTextEditorControllerProtocol) -> Void,
        onEndEditing: @escaping (String?, SingleLineTextEditorControllerProtocol) -> Void
    ) {
        self.onCancelEditing = onCancelEditing
        self.onEndEditing = onEndEditing
    }

    internal func dismiss() {
        _dismissCallCount += 1
    }
}
