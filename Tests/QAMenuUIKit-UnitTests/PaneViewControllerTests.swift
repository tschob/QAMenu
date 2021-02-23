//
//  PaneViewControllerTests.swift
//
//  Created by Hans Seiffert on 24.11.20.
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
@testable import QAMenuUIKit
import QAMenu

class PaneViewControllerTests: XCTestCase {

    // MARK: - init

    func test_init_storesPane() throws {
        let pane = Pane(title: .static("Pane"), groups: [])
        let sut = PaneViewController(pane: pane, qaMenu: QAMenuMock())

        XCTAssertEqual(sut.pane, pane)
    }

    func test_init_storesQAMenu() throws {
        let pane = Pane(title: .static("Pane"), groups: [])
        let qaMenu = QAMenuMock()
        let sut = PaneViewController(pane: pane, qaMenu: qaMenu)

        XCTAssertTrue(sut.qaMenu === qaMenu)
    }

    // MARK: - viewDidLoad

    func test_viewDidLoad_callsOnIsPresentedOnPane() throws {
        let mockPane = MockPane()
        let qaMenu = QAMenuMock()
        let sut = PaneViewController(pane: mockPane, qaMenu: qaMenu)

        XCTAssertEqual(mockPane._onIsPresentedCallCount, 0)

        sut.viewDidLoad()

        XCTAssertNotEqual(mockPane._onIsPresentedCallCount, 0)
    }

    // MARK: - handleRefreshControl

    func test_handleRefreshControl_callsOnOnReloadOnPane() throws {
        let mockPane = MockPane(isReloadable: true)
        let qaMenu = QAMenuMock()
        let sut = PaneViewController(pane: mockPane, qaMenu: qaMenu)

        XCTAssertEqual(mockPane._onReloadCallCount, 0)

        sut.handleRefreshControl()

        XCTAssertNotEqual(mockPane._onReloadCallCount, 1)
    }

    // MARK: - presentationContext

    func test_presentationContext_returnsItself() throws {
        let pane = Pane(title: .static("Pane"), groups: [])
        let qaMenu = QAMenuMock()
        let sut = PaneViewController(pane: pane, qaMenu: qaMenu)

        XCTAssertEqual(sut.presentationContext, sut)
    }
}
