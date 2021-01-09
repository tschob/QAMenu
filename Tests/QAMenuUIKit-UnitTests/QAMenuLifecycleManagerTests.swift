//
//  QAMenuLifecycleManagerTests.swift
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

class QAMenuLifecycleManagerTests: XCTestCase {

    var menu: QAMenu {
        return QAMenu(
            pane: RootPane(title: .static(""), items: []),
            presenterType: QAMenuUIKitPresenter.self
        )
    }
    var lastPresenter: QAMenuPresenterMock!

    func makeSut(dismissBehavior: QAMenuDismissBehavior) -> QAMenuLifecycleManager {
        self.lastPresenter = QAMenuPresenterMock(qaMenu: self.menu)
        return QAMenuLifecycleManager(
            presenter: self.lastPresenter,
            dismissBehavior: dismissBehavior
        )
    }

    // MARK: - init

    func test_init_setProperties() throws {
        let sut = self.makeSut(dismissBehavior: .neverReset)

        XCTAssertTrue(sut.presenter === self.lastPresenter)
        XCTAssertEqual(sut.dismissBehavior, .neverReset)
    }

    // MARK: - presenter

    func test_presenter_isNotReferencedStrongly() throws {
        var presenter: QAMenuPresenter? = QAMenuPresenterMock(qaMenu: self.menu)
        let sut = QAMenuLifecycleManager(
            presenter: presenter!,
            dismissBehavior: .neverReset
        )

        presenter = nil

        XCTAssertNil(sut.presenter)
    }

    // MARK: - dismissBehavior

    func test_dismissBehavior_whenBeingChangedToResetImmediately_isUpdated() throws {
        let sut = self.makeSut(dismissBehavior: .neverReset)

        sut.dismissBehavior = .resetImmediately

        XCTAssertEqual(sut.dismissBehavior, .resetImmediately)
    }

    // MARK: - onQAMenuWasClosed

    func test_onQAMenuWasClosed_whenPresenterIsNil_doesNotCrash() throws {
        var presenter: QAMenuPresenter? = QAMenuPresenterMock(qaMenu: self.menu)
        let sut = QAMenuLifecycleManager(
            presenter: presenter!,
            dismissBehavior: .resetImmediately
        )
        presenter = nil

        sut.onQAMenuWasClosed()

        let delay = expectation(description: "execution is delayed")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            delay.fulfill()
        }
        wait(for: [delay], timeout: 0.02)

        XCTAssert(true, "onQAMenuWasClosed did not crash when presenter is nil")
    }

    func test_onQAMenuWasClosed_whenResetImmediately_resetsTheMenuImmediately() throws {
        let sut = self.makeSut(dismissBehavior: .resetImmediately)
        XCTAssertEqual(self.lastPresenter._resetRootViewControllerCount, 0)

        sut.onQAMenuWasClosed()

        let delay = expectation(description: "execution is delayed")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            delay.fulfill()
        }
        wait(for: [delay], timeout: 0.02)

        XCTAssertEqual(self.lastPresenter._resetRootViewControllerCount, 1)
    }

    func test_onQAMenuWasClosed_whenResetAfter0_resetsTheMenuImmediately() throws {
        let sut = self.makeSut(dismissBehavior: .resetAfter(0))
        XCTAssertEqual(self.lastPresenter._resetRootViewControllerCount, 0)

        sut.onQAMenuWasClosed()

        let delay = expectation(description: "execution is delayed")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            delay.fulfill()
        }
        wait(for: [delay], timeout: 0.02)

        XCTAssertEqual(self.lastPresenter._resetRootViewControllerCount, 1)
    }

    func test_onQAMenuWasClosed_whenResetAfter1_resetsTheMenuAfter1Second() throws {
        let sut = self.makeSut(dismissBehavior: .resetAfter(1))
        XCTAssertEqual(self.lastPresenter._resetRootViewControllerCount, 0)
        // Verify that reset is not called too early
        let notCalledTooEarlyExpectation = expectation(description: "reset is not called too early")
        notCalledTooEarlyExpectation.isInverted = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.lastPresenter._resetRootViewControllerCount, 0)
            notCalledTooEarlyExpectation.fulfill()
        }

        sut.onQAMenuWasClosed()

        wait(for: [notCalledTooEarlyExpectation], timeout: 0.99)

        // Verify that reset is called afterwards
        let delay = expectation(description: "execution is delayed")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            delay.fulfill()
        }
        wait(for: [delay], timeout: 0.02)

        XCTAssertEqual(self.lastPresenter._resetRootViewControllerCount, 1)
    }

    func test_onQAMenuWasClosed_whenNeverReset_doesNotResetTheMenu() throws {
        let sut = self.makeSut(dismissBehavior: .neverReset)
        XCTAssertEqual(self.lastPresenter._resetRootViewControllerCount, 0)
        // Verify that reset is not called
        let notCalledExpectation = expectation(description: "reset is not called")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.lastPresenter._resetRootViewControllerCount == 0 {
                notCalledExpectation.fulfill()
            }
        }

        sut.onQAMenuWasClosed()

        wait(for: [notCalledExpectation], timeout: 1)
    }

    // MARK: - onQAMenuWillOpen

    func test_onQAMenuWillOpen_whenPresenterIsNil_doesNotCrash() throws {
        var presenter: QAMenuPresenter? = QAMenuPresenterMock(qaMenu: self.menu)
        let sut = QAMenuLifecycleManager(
            presenter: presenter!,
            dismissBehavior: .neverReset
        )
        presenter = nil

        sut.onQAMenuWillOpen()

        XCTAssert(true, "onQAMenuWillOpen did not crash when presenter is nil")
    }

    func test_onQAMenuWillOpen_whenLifecylceIs0_increasesIt() throws {
        let sut = self.makeSut(dismissBehavior: .neverReset)
        XCTAssertEqual(sut.lifecycleId, 0)

        sut.onQAMenuWillOpen()

        XCTAssertEqual(sut.lifecycleId, 1)
    }

    func test_onQAMenuWillOpen_whenLifecylceIs1_increasesIt() throws {
        let sut = self.makeSut(dismissBehavior: .neverReset)
        XCTAssertEqual(sut.lifecycleId, 0)

        sut.onQAMenuWillOpen()
        sut.onQAMenuWillOpen()

        XCTAssertEqual(sut.lifecycleId, 2)
    }

    func test_onQAMenuWillOpen_whenResetImmediately_cancelsOngoingReset() throws {
        let sut = self.makeSut(dismissBehavior: .resetImmediately)

        sut.onQAMenuWasClosed()
        sut.onQAMenuWillOpen()

        let delay = expectation(description: "execution is delayed")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            delay.fulfill()
        }
        wait(for: [delay], timeout: 0.02)

        XCTAssertEqual(self.lastPresenter._resetRootViewControllerCount, 0)
    }

    func test_onQAMenuWillOpen_whenResetAfter1_cancelsOngoingReset() throws {
        let sut = self.makeSut(dismissBehavior: .resetAfter(1))
        XCTAssertEqual(self.lastPresenter._resetRootViewControllerCount, 0)
        // Verify that reset is not called too early
        let notCalledTooEarlyExpectation = expectation(description: "reset is not called too early")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            XCTAssertEqual(self.lastPresenter._resetRootViewControllerCount, 0)
            notCalledTooEarlyExpectation.fulfill()
        }

        sut.onQAMenuWasClosed()
        sut.onQAMenuWillOpen()

        wait(for: [notCalledTooEarlyExpectation], timeout: 1.2)
    }
}
