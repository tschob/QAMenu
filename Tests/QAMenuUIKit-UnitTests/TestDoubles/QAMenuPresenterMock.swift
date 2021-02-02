//
//  QAMenuPresenterMock.swift
//
//  Created by Hans Seiffert on 22.11.20.
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

import XCTest
import QAMenu
@testable import QAMenuUIKit

class QAMenuPresenterMock: QAMenuPresenter {

    var _resetRootViewControllerCount = 0

    var dismissBehavior: QAMenu.DismissBehavior

    // MARK: - Initialization

    required init(
        qaMenu: QAMenu,
        dismissBehavior: QAMenu.DismissBehavior = .neverReset
    ) {
        self.dismissBehavior = dismissBehavior
    }

    // MARK: - Methods

    func toggleVisibility(completion: @escaping (QAMenuState) -> Void) {}

    func show(completion: @escaping () -> Void) {}

    func hide(completion: @escaping () -> Void) { }

    func navigateToRootPane() {}

    func resetRootViewController() {
        _resetRootViewControllerCount += 1
    }
}
