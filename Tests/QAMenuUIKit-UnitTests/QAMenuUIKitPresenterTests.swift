//
//  QAMenuUIKitPresenterTests.swift
//
//  Created by Hans Seiffert on 19.11.20.
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

class QAMenuUIKitPresenterTests: XCTestCase {

    var menu: QAMenu!
    var sut: QAMenuUIKitPresenter!

    override func setUpWithError() throws {
        UIView.setAnimationsEnabled(false)

        self.menu = QAMenu(
            pane: RootPane(title: .static(""), items: []),
            presenterType: QAMenuUIKitPresenter.self
        )
        self.sut = QAMenuUIKitPresenter(qaMenu: self.menu, dismissBehavior: .resetAfter(30))
        self.sut.ui.register(RootPaneUIRepresentableMock.self, for: RootPane.self)
    }

    override func tearDownWithError() throws {
        UIView.setAnimationsEnabled(true)
    }

    // MARK: - init

    func test_init_doesNotSetupTheWindow() throws {
        // Verify that the window isn't setup
        // This is important to allow the customization of e.g. the RootPane
        XCTAssertNil(self.sut.window.rootViewController)
    }

    func test_init_registersPaneViewController_forRootPane() throws {
        // Recreate sut to only use default elements
        self.sut = QAMenuUIKitPresenter(qaMenu: self.menu, dismissBehavior: .neverReset)
        XCTAssert(self.sut.ui.retrieve(for: RootPane.self) is PaneViewController.Type)
    }

    func test_init_registersPaneViewController_forPane() throws {
        XCTAssert(self.sut.ui.retrieve(for: Pane.self) is PaneViewController.Type)
    }

    func test_init_registersStringItemView_forChildPaneItem() throws {
        XCTAssert(self.sut.ui.retrieve(for: ChildPaneItem.self) is StringItemView.Type)
    }

    func test_init_registersBooleanItemView_forBoolItem() throws {
        XCTAssert(self.sut.ui.retrieve(for: BoolItem.self) is BooleanItemView.Type)
    }

    func test_init_registersStringItemView_forStringItem() throws {
        XCTAssert(self.sut.ui.retrieve(for: StringItem.self) is StringItemView.Type)
    }

    func test_init_registersButtonItemView_forButtonItem() throws {
        XCTAssert(self.sut.ui.retrieve(for: ButtonItem.self) is ButtonItemView.Type)
    }

    func test_init_setsDismissBehaviorTo30() throws {
        XCTAssertEqual(self.sut.dismissBehavior, .resetAfter(30))
    }

    // MARK: - dismissBehavior

    func test_dismissBehavior_changesWhenBeingUpdated() throws {
        self.sut.dismissBehavior = .resetImmediately
        XCTAssertEqual(self.sut.dismissBehavior, .resetImmediately)
    }

    // MARK: - dismissBehavior

    func test_visiblePresentationContext_whenOnRootPane_returnsNavigaqtionController() throws {
        let windowSetupExpectation = expectation(description: "window is setup")
        self.sut.show(completion: {
            windowSetupExpectation.fulfill()
        })
        wait(for: [windowSetupExpectation], timeout: 0.1)

        XCTAssertTrue(self.sut.window.rootViewController is UINavigationController)
        XCTAssertEqual(self.sut.visiblePresentationContext, self.sut.window.rootViewController)
    }

    func test_visiblePresentationContext_whenOnNestedPane_returnsNavigaqtionController() throws {
        let windowSetupExpectation = expectation(description: "window is setup")
        self.sut.show(completion: {
            windowSetupExpectation.fulfill()
        })
        wait(for: [windowSetupExpectation], timeout: 0.1)

        self.paneViewControllerMock(at: 0).show(RootPaneUIRepresentableMock(), sender: nil)

        XCTAssertTrue(self.sut.window.rootViewController is UINavigationController)
        XCTAssertEqual(self.sut.visiblePresentationContext, self.sut.window.rootViewController)
    }

    // MARK: - toggleVisibility

    func test_toggleVisibility_whenOpen_callsCompletionClosureWithClosed() throws {
        self.sut.state = .open

        let closedExpectation = expectation(description: "completion is called with new state closed")
        closedExpectation.assertForOverFulfill = true
        self.sut.toggleVisibility { newState in
            if newState == .closed {
                closedExpectation.fulfill()
            }
        }

        wait(for: [closedExpectation], timeout: 0.1)
    }

    func test_toggleVisibility_whenClosed_callsCompletionClosureWithOpen() throws {
        self.sut.state = .closed

        let openExpectation = expectation(description: "completion is called with new state open")
        openExpectation.assertForOverFulfill = true
        self.sut.toggleVisibility { newState in
            if newState == .open {
                openExpectation.fulfill()
            }
        }

        wait(for: [openExpectation], timeout: 0.1)
    }

    // MARK: - show

    func test_show_whenQAMenuIsNil_doesnNotCrash() throws {
        self.sut.qaMenu = nil

        let completionExpectation = expectation(description: "completion is called")
        completionExpectation.assertForOverFulfill = true
        self.sut.show {
            completionExpectation.fulfill()
        }

        wait(for: [completionExpectation], timeout: 0.1)
    }

    func test_show_whenClosed_callsCompletionClosure() throws {
        self.sut.state = .closed

        let completionExpectation = expectation(description: "completion is called")
        completionExpectation.assertForOverFulfill = true
        self.sut.show {
            completionExpectation.fulfill()
        }

        wait(for: [completionExpectation], timeout: 0.1)
    }

    func test_show_whenOpen_callsCompletionClosure() throws {
        self.sut.state = .open

        let completionExpectation = expectation(description: "completion is called")
        completionExpectation.assertForOverFulfill = true
        self.sut.show {
            completionExpectation.fulfill()
        }

        wait(for: [completionExpectation], timeout: 0.1)
    }

    func test_show_movesMenuIntoVisibleArea() throws {
        let frameExpectation = expectation(description: "menu frame and screen frame intersect")
        sut.show(completion: {
            if UIScreen.main.bounds.intersects(self.sut.window.frame) {
                frameExpectation.fulfill()
            }
        })

        wait(for: [frameExpectation], timeout: 0.1)
    }

    // MARK: - hide

    func test_hide_whenQAMenuIsNil_doesnNotCrash() throws {
        self.sut.qaMenu = nil

        let completionExpectation = expectation(description: "completion is called")
        completionExpectation.assertForOverFulfill = true
        self.sut.hide {
            completionExpectation.fulfill()
        }

        wait(for: [completionExpectation], timeout: 0.1)
    }

    func test_hide_whenOpen_callsCompletionClosure() throws {
        self.sut.state = .open

        let completionExpectation = expectation(description: "completion is called")
        completionExpectation.assertForOverFulfill = true
        self.sut.hide {
            completionExpectation.fulfill()
        }

        wait(for: [completionExpectation], timeout: 0.1)
    }

    func test_hide_whenClosed_callsCompletionClosure() throws {
        self.sut.state = .closed

        let completionExpectation = expectation(description: "completion is called")
        completionExpectation.assertForOverFulfill = true
        self.sut.hide {
            completionExpectation.fulfill()
        }

        wait(for: [completionExpectation], timeout: 0.1)
    }

    func test_hide_movesMenuOutOfVisibleArea() throws {
        let frameExpectation = expectation(description: "menu frame and screen frame don't intersect")
        sut.hide(completion: {
            if !UIScreen.main.bounds.intersects(self.sut.window.frame) {
                frameExpectation.fulfill()
            }
        })

        wait(for: [frameExpectation], timeout: 0.1)
    }

    // MARK: - navigateToRootPane

    func test_navigateToRootPane_whenBeingOnRootPane_scrollsToTop() throws {
        let windowSetupExpectation = expectation(description: "window is setup")
        self.sut.show(completion: {
            windowSetupExpectation.fulfill()
        })
        wait(for: [windowSetupExpectation], timeout: 0.1)

        let viewController = self.paneViewControllerMock(at: 0)
        XCTAssertEqual(viewController._scrollToTopCount, 0)

        self.sut.navigateToRootPane()

        XCTAssertEqual(viewController._scrollToTopCount, 1)
    }

    func test_navigateToRootPane_whenBeingOnNestedPane_scrollsToTop() throws {
        let windowSetupExpectation = expectation(description: "window is setup")
        self.sut.show(completion: {
            windowSetupExpectation.fulfill()
        })
        wait(for: [windowSetupExpectation], timeout: 0.1)

        self.paneViewControllerMock(at: 0).show(RootPaneUIRepresentableMock(), sender: nil)
        let rootViewController = self.paneViewControllerMock(at: 0)
        XCTAssertEqual(rootViewController._scrollToTopCount, 0)

        self.sut.navigateToRootPane()

        XCTAssertEqual(rootViewController._scrollToTopCount, 1)
    }

    // MARK: - resetRootViewController

    func test_resetRootViewController_removesRootViewController() throws {
        let windowSetupExpectation = expectation(description: "window is setup")
        self.sut.show(completion: {
            windowSetupExpectation.fulfill()
        })
        wait(for: [windowSetupExpectation], timeout: 0.1)
        XCTAssertNotNil(self.sut.window.rootViewController)

        self.sut.resetRootViewController()

        XCTAssertNil(self.sut.window.rootViewController)
    }

    func test_navigateToRootPane_whenHavingNoRootViewController_doesNotCrash() throws {
        self.sut.resetRootViewController()

        self.sut.navigateToRootPane()

        XCTAssert(true, "qa menu didn't crash when calling navigateToRootPane without a root view controller")
    }

    // MARK: - Helper

    var navigationController: UINavigationController {
        return self.sut.window.rootViewController as! UINavigationController
    }

    func paneViewControllerMock(at index: Int) -> RootPaneUIRepresentableMock {
        let navigationController = self.navigationController
        return navigationController.viewControllers[index] as! RootPaneUIRepresentableMock
    }
}
