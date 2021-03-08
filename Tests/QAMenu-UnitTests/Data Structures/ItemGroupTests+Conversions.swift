//
//  ItemGroupTests+Conversions.swift
//
//  Created by Hans Seiffert on 10.11.20.
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

extension ItemGroupTests {

    // MARK: - asPane

    func test_itemGroup_asPane_whenPassingOnlyMandatoryParameters_returnsExpectedPane() throws {
        let group = MockGroup(
            title: "groupTitle",
            items: []
        )

        let pane = group.asPane()

        Pane._assertInitProperties(
            pane,
            title: "groupTitle",
            itemGroups: [group]
        )
    }

    func test_itemGroup_asPane_whenPassingAllParameters_returnsExpectedPane() throws {
        let group = MockGroup(
            title: "groupTitle",
            items: [
                MockItem(),
                MockItem()
            ]
        )

        let pane = group.asPane(
            title: .static("title"),
            isReloadable: true,
            isSearchable: true
        )

        Pane._assertInitProperties(
            pane,
            title: "title",
            itemGroups: [group],
            isReloadable: true,
            isSearchable: true
        )
    }

    // MARK: - asPane (Array)

    func test_itemGroups_asPane_whenPassingOnlyMandatoryParameters_returnsExpectedPane() throws {
        let groups = [
            MockGroup(
                title: "groupTitle1",
                items: []
            ),
            MockGroup(
                title: "groupTitle2",
                items: [
                    MockItem()
                ]
            )
        ]

        let pane = groups.asPane(
            title: .static("title")
        )

        Pane._assertInitProperties(
            pane,
            title: "title",
            itemGroups: groups
        )
    }

    func test_itemGroups_asPane_whenPassingAllParameters_returnsExpectedPane() throws {
        let groups = [
            MockGroup(
                title: "groupTitle1",
                items: [
                    MockItem()
                ]
            ),
            MockGroup(
                title: "groupTitle2",
                items: [
                    MockItem(),
                    MockItem()
                ]
            )
        ]

        let pane = groups.asPane(
            title: .static("title"),
            isReloadable: true,
            isSearchable: true
        )

        Pane._assertInitProperties(
            pane,
            title: "title",
            itemGroups: groups,
            isReloadable: true,
            isSearchable: true
        )
    }

    // MARK: - asChildPaneItem

    func test_itemGroup_asChildPaneItem_whenPassingOnlyMandatoryParameters_returnsExpectedChildPaneItem() throws {
        let group = MockGroup(
            title: "groupTitle",
            items: []
        )

        let childPaneItem = group.asChildPaneItem()

        ChildPaneItem._assertInitProperties(
            childPaneItem,
            itemGroups: [group],
            title: "groupTitle"
        )
    }

    func test_itemGroup_asChildPaneItem_whenPassingAllParameters_returnsExpectedChildPaneItem() throws {
        let group = MockGroup(
            title: "groupTitle",
            items: [
                MockItem(),
                MockItem()
            ]
        )

        let childPaneItem = group.asChildPaneItem(
            title: .static("title"),
            value: .static("value"),
            footerText: .static("footer"),
            fallbackString: "fallback",
            isPaneReloadable: true,
            isPaneSearchable: true
        )
        .withLayoutType(.static(.vertical(.autoGrow)))
        .withTitleTextAttributes(.static(TextAttributes(textStyle: .caption1, lineBreak: .wrapByCharacter)))
        .withValueTextAttributes(.static(TextAttributes(textStyle: .footnote, lineBreak: .wrapByWord)))

        ChildPaneItem._assertInitProperties(
            childPaneItem,
            itemGroups: [group],
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

    func test_itemGroups_asChildPaneItem_whenPassingOnlyMandatoryParameters_returnsExpectedChildPaneItem() throws {
        let groups = [
            MockGroup(
                title: "groupTitle1",
                items: []
            ),
            MockGroup(
                title: "groupTitle2",
                items: [
                    MockItem()
                ]
            )
        ]

        let childPaneItem = groups.asChildPaneItem(title: .static("title"))

        ChildPaneItem._assertInitProperties(
            childPaneItem,
            itemGroups: groups,
            title: "title"
        )
    }

    func test_itemGroups_asChildPaneItem_whenPassingAllParameters_returnsExpectedChildPaneItem() throws {
        let groups = [
            MockGroup(
                title: "groupTitle1",
                items: [
                    MockItem()
                ]
            ),
            MockGroup(
                title: "groupTitle2",
                items: [
                    MockItem(),
                    MockItem()
                ]
            )
        ]

        let childPaneItem = groups.asChildPaneItem(
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
            itemGroups: groups,
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
