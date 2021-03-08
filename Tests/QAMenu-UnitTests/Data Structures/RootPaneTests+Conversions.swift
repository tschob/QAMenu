//
//  RootPaneTests+Conversions.swift
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

extension RootPaneTests {

    // MARK: - asChildPaneItem

    func test_rootPane_asChildPaneItem_whenPassingOnlyMandatoryParameters_returnsChildPaneItem() throws {
        let rootPane = RootPane(
            title: .static("rootPaneTitle"),
            groups: [],
            isSearchable: true
        )

        let childPaneItem = rootPane.asChildPaneItem()

        ChildPaneItem._assertInitProperties(
            childPaneItem,
            pane: rootPane,
            title: "rootPaneTitle"
        )
    }

    func test_rootPanes_asChildPaneItem_whenPassingAllParameters_returnsChildPaneItem() throws {
        let rootPane = RootPane(
            title: .static("rootPaneTitle"),
            groups: []
        )

        let childPaneItem = rootPane.asChildPaneItem(
            value: .static("value"),
            footerText: .static("footer"),
            layoutType: .static(.vertical(.autoGrow)),
            fallbackString: "fallback"
        )
        .withTitleTextAttributes(.static(TextAttributes(textStyle: .caption1, lineBreak: .wrapByCharacter)))
        .withValueTextAttributes(.static(TextAttributes(textStyle: .footnote, lineBreak: .wrapByWord)))

        ChildPaneItem._assertInitProperties(
            childPaneItem,
            pane: rootPane,
            title: "rootPaneTitle",
            value: "value",
            footerText: "footer",
            fallbackString: "fallback",
            layoutType: .vertical(.autoGrow),
            titleTextAttributes: TextAttributes(textStyle: .caption1, lineBreak: .wrapByCharacter),
            valueTextAttributes: TextAttributes(textStyle: .footnote, lineBreak: .wrapByWord)
        )
    }

    // MARK: - asChildPaneItems (Array)

    func test_rootPanes_asChildPaneItems_whenPassingOnlyMandatoryParameters_returnsChildPaneItems() throws {
        let rootPanes = [
            RootPane(title: .static("rootPaneTitle"), groups: [], isSearchable: true)
        ]

        let childPaneItems = rootPanes.asChildPaneItems()
        var index = 0
        childPaneItems.forEach { childPaneItem in
            ChildPaneItem._assertInitProperties(
                childPaneItem,
                pane: rootPanes[index],
                title: "rootPaneTitle"
            )
            index += 1
        }
    }

    func test_rootPanes_asChildPaneItems_PassingAllParameters_returnsChildPaneItems() throws {
        let rootPanes = [
            RootPane(title: .static("rootPaneTitle1"), groups: [], isSearchable: true),
            RootPane(title: .static("rootPaneTitle2"), groups: [], isSearchable: true)
        ]

        let childPaneItems = rootPanes.asChildPaneItems(
            footerText: .static("footer")
        )

        var index = 0
        childPaneItems.forEach { childPaneItem in
            ChildPaneItem._assertInitProperties(
                childPaneItem,
                pane: rootPanes[index],
                title: "rootPaneTitle\(index + 1)",
                footerText: "footer"
            )
            index += 1
        }
    }
}
