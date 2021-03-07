//
//  ItemTests.swift
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

extension ItemTests {

    // MARK: - asItemGroup

    func test_item_asItemGroup_whenPassingOnlyMandatoryParameters_returnsExpectedGroup() throws {
        let item = MockItem()

        let pane = item.asItemGroup()

        ItemGroup._assertInitProperties(
            pane,
            items: [item]
        )
    }

    func test_item_asItemGroup_whenPassingAllParameters_returnsExpectedGroup() throws {
        let item = MockItem()

        let pane = item.asItemGroup(
            title: .static("title"),
            footerText: .static("footer")
        )

        ItemGroup._assertInitProperties(
            pane,
            title: "title",
            items: [item],
            footerText: "footer"
        )
    }

    // MARK: - asItemGroup (Array)

    func test_items_asItemGroup_whenPassingOnlyMandatoryParameters_returnsExpectedGroup() throws {
        let items: [MockItem] = []

        let pane = items.asItemGroup()

        ItemGroup._assertInitProperties(
            pane,
            items: items
        )
    }

    func test_items_asItemGroup_whenPassingAllParameters_returnsExpectedGroup() throws {
        let items = [
            MockItem(),
            MockItem()
        ]

        let pane = items.asItemGroup(
            title: .static("title"),
            footerText: .static("footer")
        )

        ItemGroup._assertInitProperties(
            pane,
            title: "title",
            items: items,
            footerText: "footer"
        )
    }

    // MARK: - asPane

    func test_item_asPane_whenPassingOnlyMandatoryParameters_returnsExpectedPane() throws {
        let item = MockItem()

        let pane = item.asPane(
            title: .static("title")
        )

        Pane._assertInitProperties(
            pane,
            title: "title",
            items: [item]
        )
    }

    func test_item_asPane_whenPassingAllParameters_returnsExpectedPane() throws {
        let item = MockItem()

        let pane = item.asPane(
            title: .static("title"),
            isReloadable: true,
            isSearchable: true
        )

        Pane._assertInitProperties(
            pane,
            title: "title",
            items: [item],
            isReloadable: true,
            isSearchable: true
        )
    }

    // MARK: - asPane (Array)

    func test_items_asPane_whenPassingOnlyMandatoryParameters_returnsExpectedPane() throws {
        let items: [MockItem] = []

        let pane = items.asPane(
            title: .static("title")
        )

        Pane._assertInitProperties(
            pane,
            title: "title",
            items: items
        )
    }

    func test_items_asPane_whenPassingAllParameters_returnsExpectedPane() throws {
        let items = [
            MockItem(),
            MockItem()
        ]

        let pane = items.asPane(
            title: .static("title"),
            isReloadable: true,
            isSearchable: true
        )

        Pane._assertInitProperties(
            pane,
            title: "title",
            items: items,
            isReloadable: true,
            isSearchable: true
        )
    }

    // MARK: - asChildPaneItem

    func test_item_asChildPaneItem_whenPassingOnlyMandatoryParameters_returnsExpectedChildPaneItem() throws {
        let item = MockItem()

        let childPaneItem = item.asChildPaneItem(
            title: .static("title")
        )

        ChildPaneItem._assertInitProperties(
            childPaneItem,
            items: [item],
            title: "title"
        )
    }

    func test_item_asChildPaneItem_whenPassingAllParameters_returnsExpectedChildPaneItem() throws {
        let item = MockItem()

        let childPaneItem = item.asChildPaneItem(
            title: .static("title"),
            value: .static("value"),
            footerText: .static("footer"),
            layoutType: .static(.vertical(.autoGrow)),
            fallbackString: "fallback",
            isPaneReloadable: true,
            isPaneSearchable: true
        )
        .withTitleTextAttributes(.static(TextAttributes(textStyle: .caption1, lineBreak: .wrapByCharacter)))
        .withValueTextAttributes(.static(TextAttributes(textStyle: .footnote, lineBreak: .wrapByWord)))

        ChildPaneItem._assertInitProperties(
            childPaneItem,
            items: [item],
            title: "title",
            value: "value",
            footerText: "footer",
            fallbackString: "fallback",
            isPaneReloadable: true,
            isPaneSearchable: true,
            layoutType: .vertical(.autoGrow),
            titleTextAttributes: TextAttributes(textStyle: .caption1, lineBreak: .wrapByCharacter),
            valueTextAttributes: TextAttributes(textStyle: .footnote, lineBreak: .wrapByWord)
        )
    }

    // MARK: - asChildPaneItem (Array)

    func test_items_asChildPaneItem_whenPassingOnlyMandatoryParameters_returnsExpectedChildPaneItem() throws {
        let items = [
            MockItem
        ]()

        let childPaneItem = items.asChildPaneItem(
            title: .static("title")
        )

        ChildPaneItem._assertInitProperties(
            childPaneItem,
            items: items,
            title: "title"
        )
    }

    func test_items_asChildPaneItem_whenPassingAllParameters_returnsExpectedChildPaneItem() throws {
        let items = [
            MockItem(),
            MockItem()
        ]

        let childPaneItem = items.asChildPaneItem(
            title: .static("title"),
            value: .static("value"),
            footerText: .static("footer"),
            layoutType: .static(.vertical(.autoGrow)),
            fallbackString: "fallback",
            isPaneReloadable: true,
            isPaneSearchable: true
        )
        .withTitleTextAttributes(.static(TextAttributes(textStyle: .caption1, lineBreak: .wrapByCharacter)))
        .withValueTextAttributes(.static(TextAttributes(textStyle: .footnote, lineBreak: .wrapByWord)))

        ChildPaneItem._assertInitProperties(
            childPaneItem,
            items: items,
            title: "title",
            value: "value",
            footerText: "footer",
            fallbackString: "fallback",
            isPaneReloadable: true,
            isPaneSearchable: true,
            layoutType: .vertical(.autoGrow),
            titleTextAttributes: TextAttributes(textStyle: .caption1, lineBreak: .wrapByCharacter),
            valueTextAttributes: TextAttributes(textStyle: .footnote, lineBreak: .wrapByWord)
        )
    }
}
