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

    func test_asChildPaneItem_returnsChildPaneItem() throws {
        let sut = Pane(title: .static("abc"), groups: [], isSearchable: true)

        let childPaneItem = sut.asChildPaneItem()

        childPaneItem.assert_pane_equals(sut)
        XCTAssertNil(childPaneItem.footerText)
    }

    func test_asChildPaneItem_whenGivenFooterText_returnsChildPaneItem() throws {
        let sut = Pane(title: .static("abc"), groups: [])

        let childPaneItem = sut.asChildPaneItem(footerText: .static("footer"))

        childPaneItem.assert_pane_equals(sut)
        XCTAssertEqual(childPaneItem.footerText?(), "footer")
    }

    // MARK: - asChildPaneItems

    func test_asChildPaneItems_returnsChildPaneItems() throws {
        let sut = [
            Pane(title: .static("def"), groups: [], isSearchable: true)
        ]

        let childPaneItems = sut.asChildPaneItems()

        XCTAssertEqual(childPaneItems.count, 1)
        childPaneItems[0].assert_pane_equals(sut[0])
        XCTAssertNil(childPaneItems[0].footerText)
    }

    func test_asChildPaneItems_whenGivenFooterText_returnsChildPaneItems() throws {
        let sut = [
            Pane(title: .static("abc"), groups: [], isSearchable: true),
            Pane(title: .static("def"), groups: [], isSearchable: true)
        ]

        let childPaneItems = sut.asChildPaneItems(footerText: .static("footer"))

        XCTAssertEqual(childPaneItems.count, 2)
        childPaneItems[0].assert_pane_equals(sut[0])
        XCTAssertEqual(childPaneItems[0].footerText?(), "footer")
        childPaneItems[1].assert_pane_equals(sut[1])
        XCTAssertEqual(childPaneItems[1].footerText?(), "footer")
    }
}
