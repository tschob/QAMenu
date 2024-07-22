//
//  MockQAMenuPresenter.swift
//
//  Created by Hans Seiffert on 15.11.20.
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
import Combine
import QAMenu

class MockQAMenuPresenter: QAMenuPresenter {

    var _toggleVisibilityToState = QAMenuState.open
    let _toggleVisibility = PassthroughSubject<QAMenuState, Never>()

    let _navigateToRootPane = PassthroughSubject<Void, Never>()

    let _show = PassthroughSubject<Void, Never>()
    let _hide = PassthroughSubject<Void, Never>()

    var dismissBehavior: QAMenu.DismissBehavior

    required init(qaMenu: QAMenu, dismissBehavior: QAMenu.DismissBehavior = .neverReset) {
        self.dismissBehavior = dismissBehavior
    }

    func toggleVisibility(completion: @escaping (QAMenuState) -> Void) {
        completion(self._toggleVisibilityToState)
        _toggleVisibility.send(self._toggleVisibilityToState)
    }

    func show(completion: @escaping () -> Void) {
        completion()
        _show.send()
    }

    func hide(completion: @escaping () -> Void) {
        completion()
        _hide.send()
    }

    func navigateToRootPane() {
        _navigateToRootPane.send()
    }

    func resetRootViewController() {}
}
