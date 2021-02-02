//
//  PaneTests+Conversions.swift
//
//  Created by Hans Seiffert on 08.11.20.
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
@testable import QAMenu

extension PaneTests {

    // MARK: - asChildPaneItem

    func test_pane_asChildPaneItem_whenPassingOnlyMandatoryParameters_returnsExpectedChildPaneItem() throws {
        let pane = MockPane(title: "abc", groups: [])

        let childPaneItem = pane.asChildPaneItem()

        ChildPaneItem._assertInitProperties(
            childPaneItem,
            pane: pane,
            title: "abc"
        )
    }

    func test_pane_asChildPaneItem_whenPassingAllParameters_returnsExpectedChildPaneItem() throws {
        let pane = MockPane(title: "abc", groups: [])

        let childPaneItem = pane.asChildPaneItem(
            value: .static("value"),
            footerText: .static("footer"),
            layoutType: .static(.vertical(.singleLine)),
            fallbackString: "fallback"
        )

        ChildPaneItem._assertInitProperties(
            childPaneItem,
            pane: pane,
            title: "abc",
            value: "value",
            footerText: "footer",
            layoutType: .vertical(.singleLine),
            fallbackString: "fallback"
        )
    }

    // MARK: - asChildPaneItems (Array)

    func test_panes_asChildPaneItems_whenPassingOnlyMandatoryParameters_returnsExpectedChildPaneItems() throws {
        let panes = [
            MockPane(title: "abc", groups: [])
        ]

        let childPaneItems = panes.asChildPaneItems()

        XCTAssertEqual(childPaneItems.count, 1)
        ChildPaneItem._assertInitProperties(
            childPaneItems[0],
            pane: panes[0],
            title: "abc"
        )
    }

    func test_panes_asChildPaneItems_whenPassingAllParameters_returnsExpectedChildPaneItems() throws {
        let panes = [
            MockPane(title: "abc", groups: []),
            MockPane(title: "def", groups: [])
        ]

        let childPaneItems = panes.asChildPaneItems(
            footerText: .static("footer")
        )

        XCTAssertEqual(childPaneItems.count, 2)
        ChildPaneItem._assertInitProperties(
            childPaneItems[0],
            pane: panes[0],
            title: "abc",
            value: nil,
            footerText: "footer",
            layoutType: .horizontal(.singleLine),
            fallbackString: ""
        )
        ChildPaneItem._assertInitProperties(
            childPaneItems[1],
            pane: panes[1],
            title: "def",
            value: nil,
            footerText: "footer",
            layoutType: .horizontal(.singleLine),
            fallbackString: ""
        )
    }
}
