//
//  QAMenuLifecycleManager.swift
//
//  Created by Hans Seiffert on 06.09.20.
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
import QAMenu
import QAMenuUtils

internal class QAMenuLifecycleManager {

    // MARK: - Properties (Internal)

    internal var dismissBehavior: QAMenuDismissBehavior

    internal private(set) weak var presenter: QAMenuPresenter?

    // MARK: - Properties (Private)

    internal private(set) var lifecycleId = 0

    // MARK: - Initialization

    internal init(
        presenter: QAMenuPresenter,
        dismissBehavior: QAMenuDismissBehavior
    ) {
        self.presenter = presenter
        self.dismissBehavior = dismissBehavior
    }

    // MARK: - Methods (Internal)

    internal func onQAMenuWasClosed() {
        switch self.dismissBehavior {
        case .resetImmediately:
            DispatchQueue.main.async(execute: self.makeResetWorkItem(forId: self.lifecycleId))
        case .resetAfter(let duration):
            let targetLifecycleId = self.lifecycleId
            DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: self.makeResetWorkItem(forId: targetLifecycleId))
        case .neverReset:
            break
        }
    }

    internal func onQAMenuWillOpen() {
        lifecycleId += 1
    }

    // MARK: - Methods (Private)

    private func makeResetWorkItem(forId targetLifecycleId: Int) -> DispatchWorkItem {
        let item = DispatchWorkItem { [weak self] in
            guard targetLifecycleId == self?.lifecycleId else {
                // swiftlint:disable:next line_length
                Logger.verbose("Don't reset the root view controller as `targetLifecycleId` (\(targetLifecycleId)) doesn't match the active one (\(String(describing: self?.lifecycleId))")
                return
            }
            Logger.verbose("Resetting the root view controller")
            self?.presenter?.resetRootViewController()
        }
        return item
    }
}
