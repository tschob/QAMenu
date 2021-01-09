//
//  QAMenuTests.swift
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
import QAMenu

class QAMenuTests: XCTestCase {

    var disposeBag = DisposeBag()

    override func setUpWithError() throws {
        QAMenu.instances.removeAll()
    }

    override func tearDownWithError() throws {
        self.disposeBag = DisposeBag()
    }

    func test_instances_hasWeakReferences() throws {
        let mockPane = RootPane(items: [])
        var sut: QAMenu? = QAMenu(pane: mockPane, presenterType: MockQAMenuPresenter.self)
        print("Print sut to avoid Xcode warning: \(String(describing: sut))")

        sut = nil

        XCTAssertEqual(QAMenu.instances.count, 1)
        XCTAssertNil(QAMenu.instances.last?.unbox)
    }

    // MARK: - Init

    func test_init_whenGivenRootPaneAndPresenter() throws {
        let mockPane = RootPane(items: [])
        let sut = QAMenu(pane: mockPane, presenterType: MockQAMenuPresenter.self)

        XCTAssertEqual(sut.pane, mockPane)
        XCTAssertEqual(sut.trigger, .shake)
        XCTAssert(sut.presenter.self is MockQAMenuPresenter)

        XCTAssertEqual(QAMenu.instances.count, 1)
        XCTAssert(QAMenu.instances.last?.unbox === sut)
    }

    // MARK: - onShakeRecognized

    func test_onShakeRecognized_whenClosed_togglesTheVisibilityToOpen() throws {
        let mockPane = RootPane(items: [])
        let sut = QAMenu(pane: mockPane, presenterType: MockQAMenuPresenter.self)
        let presenter = sut.presenter as! MockQAMenuPresenter
        presenter._toggleVisibilityToState = .open

        let toggleExpectation = expectation(description: "new state should be \(QAMenuState.open)")
        presenter
            ._toggleVisibility
            .observe { (newState: QAMenuState) in
                if newState == .open {
                    toggleExpectation.fulfill()
                } else {
                    XCTFail("\(newState) doesn't equal \(QAMenuState.open)")
                }
            }
            .disposeWith(self.disposeBag)

        sut.onShakeRecognized()

        wait(for: [toggleExpectation], timeout: 0.01)
    }

    func test_onShakeRecognized_whenClosed_callsOnDidAppear() throws {
        let mockPane = RootPane(items: [])
        let sut = QAMenu(pane: mockPane, presenterType: MockQAMenuPresenter.self)
        let presenter = sut.presenter as! MockQAMenuPresenter
        presenter._toggleVisibilityToState = .open

        let didAppearExpectation = expectation(description: "onDidAppear is called when opening the menu after a shake")
        didAppearExpectation.assertForOverFulfill = true
        sut.onDidAppear = {
            didAppearExpectation.fulfill()
        }

        sut.onShakeRecognized()

        wait(for: [didAppearExpectation], timeout: 0.01)
    }

    func test_onShakeRecognized_whenOpen_togglesTheVisibilityToOpen() throws {
        let mockPane = RootPane(items: [])
        let sut = QAMenu(pane: mockPane, presenterType: MockQAMenuPresenter.self)
        let presenter = sut.presenter as! MockQAMenuPresenter
        presenter._toggleVisibilityToState = .closed

        let toggleExpectation = expectation(description: "new state should be \(QAMenuState.closed)")
        toggleExpectation.assertForOverFulfill = true
        presenter
            ._toggleVisibility
            .observe { (newState: QAMenuState) in
                if newState == .closed {
                    toggleExpectation.fulfill()
                } else {
                    XCTFail("\(newState) doesn't equal \(QAMenuState.open)")
                }
            }
            .disposeWith(self.disposeBag)

        sut.onShakeRecognized()

        wait(for: [toggleExpectation], timeout: 0.01)
    }

    func test_onShakeRecognized_whenOpen_callsOnDidDisappear() throws {
        let mockPane = RootPane(items: [])
        let sut = QAMenu(pane: mockPane, presenterType: MockQAMenuPresenter.self)
        let presenter = sut.presenter as! MockQAMenuPresenter
        presenter._toggleVisibilityToState = .closed

        let didDisappearExpectation = expectation(description: "onDidDisappear is called when opening the menu after a shake")
        didDisappearExpectation.assertForOverFulfill = true
        sut.onDidDisappear = {
            didDisappearExpectation.fulfill()
        }

        sut.onShakeRecognized()

        wait(for: [didDisappearExpectation], timeout: 0.01)
    }

    // MARK: - navigateToRootPane

    func test_navigateToRootPane_forwardsToPresenter() throws {
        let mockPane = RootPane(items: [])
        let sut = QAMenu(pane: mockPane, presenterType: MockQAMenuPresenter.self)
        let presenter = sut.presenter as! MockQAMenuPresenter

        let navigateToRootPaneExpectation = expectation(description: "navigateToRootPane should be forwards to the presenter")
        navigateToRootPaneExpectation.assertForOverFulfill = true
        presenter
            ._navigateToRootPane
            .observe {
                navigateToRootPaneExpectation.fulfill()
            }
            .disposeWith(self.disposeBag)

        sut.navigateToRootPane()

        wait(for: [navigateToRootPaneExpectation], timeout: 0.01)
    }

    // MARK: - show

    func test_show_forwardsToPresenter() throws {
        let mockPane = RootPane(items: [])
        let sut = QAMenu(pane: mockPane, presenterType: MockQAMenuPresenter.self)
        let presenter = sut.presenter as! MockQAMenuPresenter

        let showExpectation = expectation(description: "show should be forwarded to the presenter")
        showExpectation.assertForOverFulfill = true
        presenter
            ._show
            .observe {
                showExpectation.fulfill()
            }
            .disposeWith(self.disposeBag)

        sut.show()

        wait(for: [showExpectation], timeout: 0.01)
    }

    func test_show_callsOnDidDidAppear() throws {
        let mockPane = RootPane(items: [])
        let sut = QAMenu(pane: mockPane, presenterType: MockQAMenuPresenter.self)

        let didAppearExpectation = expectation(description: "onDidAppear is called when opening the menu when calling show")
        didAppearExpectation.assertForOverFulfill = true
        sut.onDidAppear = {
            didAppearExpectation.fulfill()
        }

        sut.show()

        wait(for: [didAppearExpectation], timeout: 0.01)
    }

    // MARK: - hide

    func test_hide_forwardsToPresenter() throws {
        let mockPane = RootPane(items: [])
        let sut = QAMenu(pane: mockPane, presenterType: MockQAMenuPresenter.self)
        let presenter = sut.presenter as! MockQAMenuPresenter

        let hideExpectation = expectation(description: "hide should be forwarded to the presenter")
        hideExpectation.assertForOverFulfill = true
        presenter
            ._hide
            .observe {
                hideExpectation.fulfill()
            }
            .disposeWith(self.disposeBag)

        sut.hide()

        wait(for: [hideExpectation], timeout: 0.01)
    }

    func test_hide_callsOnDidDidDisappear() throws {
        let mockPane = RootPane(items: [])
        let sut = QAMenu(pane: mockPane, presenterType: MockQAMenuPresenter.self)

        let didDisappearExpectation = expectation(description: "onDidDisappear is called when closing the menu when calling hide")
        didDisappearExpectation.assertForOverFulfill = true
        sut.onDidDisappear = {
            didDisappearExpectation.fulfill()
        }

        sut.hide()

        wait(for: [didDisappearExpectation], timeout: 0.01)
    }
}
