//
//  PickerGroupTests+Conversions.swift
//
//  Created by Hans Seiffert on 01.01.21.
//
//  ---
//  MIT License
//
//  Copyright © 2021 Hans Seiffert
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

extension PickerGroupTests {

    // MARK: - asPane

    func test_pickerGroup_asPane_whenPassingOnlyMandatoryParameters_returnsExpectedPane() throws {
        let options: [MockPickableItem] = []
        let group = PickerGroup(
            title: .static("groupTitle"),
            options: .static(options),
            onPickedOption: { _, result in
                result(.failure("failure"))
            }
        )

        let pane = group.asPane()

        Pane._assertInitProperties(
            pane,
            title: "groupTitle",
            pickerGroups: [group],
            onPickedOptionFailure: "failure",
            testCase: self
        )
    }

    func test_pickerGroup_asPane_whenPassingAllParameters_returnsExpectedPane() throws {
        let options: [MockPickableItem] = [
            MockPickableItem(),
            MockPickableItem()
        ]
        let group = PickerGroup(
            title: .static("groupTitle"),
            options: .static(options),
            onPickedOption: { _, result in
                result(.failure("failure"))
            }
        )

        let pane = group.asPane(
            title: .static("title"),
            isReloadable: true,
            isSearchable: true
        )

        Pane._assertInitProperties(
            pane,
            title: "title",
            pickerGroups: [group],
            footerText: "footer",
            onPickedOptionFailure: "failure",
            isReloadable: true,
            isSearchable: true,
            testCase: self
        )
    }

    // MARK: - asPane (Array)

    func test_pickerGroups_asPane_whenPassingOnlyMandatoryParameters_returnsExpectedPane() throws {
        let options: [MockPickableItem] = []
        let groups = [
            PickerGroup(
                title: .static("groupTitle"),
                options: .static(options),
                onPickedOption: { _, result in
                    result(.failure("failure"))
                }
            )
        ]

        let pane = groups.asPane(
            title: .static("title")
        )

        Pane._assertInitProperties(
            pane,
            title: "title",
            pickerGroups: groups,
            onPickedOptionFailure: "failure",
            testCase: self
        )
    }

    func test_pickerGroups_asPane_whenPassingAllParameters_returnsExpectedPane() throws {
        let options: [MockPickableItem] = [
            MockPickableItem(),
            MockPickableItem()
        ]
        let groups = [
            PickerGroup(
                title: .static("groupTitle1"),
                options: .static(options),
                onPickedOption: { _, result in
                    result(.failure("failure"))
                }
            ),
            PickerGroup(
                options: .static([]),
                onPickedOption: { _, result in
                    result(.failure("failure"))
                }
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
            pickerGroups: groups,
            footerText: "footer",
            onPickedOptionFailure: "failure",
            isReloadable: true,
            isSearchable: true,
            testCase: self
        )
    }

    // MARK: - asChildPaneItem

    func test_pickerGroup_asChildPaneItem_whenPassingOnlyMandatoryParameters_returnsExpectedChildPaneItem() throws {
        let options: [MockPickableItem] = [
            MockPickableItem()
        ]
        let sut = PickerGroup(
            options: .static(options),
            onPickedOption: { _, result in
                result(.failure("failure"))
            }
        )

        let childPaneItem = sut.asChildPaneItem()

        ChildPaneItem._assertInitProperties(
            childPaneItem,
            pickerGroups: [sut],
            title: "",
            onPickedOptionFailure: "failure",
            testCase: self
        )
    }

    func test_pickerGroup_asChildPaneItem_whenPassingAllParameters_returnsExpectedChildPaneItem() throws {
        let pickerGroup = PickerGroup(
            title: .static("groupTitle"),
            options: .static([
                MockPickableItem()
            ]),
            footerText: .static("groupFooter"),
            onPickedOption: { _, result in
                result(.failure("failure"))
            }
        )

        let childPaneItem = pickerGroup.asChildPaneItem(
            title: .static("title"),
            value: .static("value"),
            footerText: .static("footer"),
            layoutType: .static(.vertical(.autoGrow)),
            fallbackString: "fallback",
            isPaneReloadable: true,
            isPaneSearchable: true
        )

        ChildPaneItem._assertInitProperties(
            childPaneItem,
            pickerGroups: [pickerGroup],
            title: "title",
            value: "value",
            footerText: "footer",
            layoutType: .vertical(.autoGrow),
            fallbackString: "fallback",
            isPaneReloadable: true,
            isPaneSearchable: true,
            onPickedOptionFailure: "failure",
            testCase: self
        )
    }

    // MARK: - asChildPaneItem (Array)

    func test_pickerGroups_asChildPaneItem_whenPassingOnlyMandatoryParameters_returnsExpectedChildPaneItem() throws {
        let options: [MockPickableItem] = [
            MockPickableItem()
        ]
        let groups = [
            PickerGroup(
                options: .static(options),
                onPickedOption: { _, result in
                    result(.failure("failure"))
                }
            )
        ]

        let childPaneItem = groups.asChildPaneItem(
            title: .static("title")
        )

        ChildPaneItem._assertInitProperties(
            childPaneItem,
            pickerGroups: groups,
            title: "title",
            onPickedOptionFailure: "failure",
            testCase: self
        )
    }

    func test_pickerGroups_asChildPaneItem_whenPassingAllParameters_returnsExpectedChildPaneItem() throws {
        let groups = [
            PickerGroup(
                options: .static([]),
                onPickedOption: { _, result in
                    result(.failure("failure"))
                }
            ),
            PickerGroup(
                title: .static("groupTitle"),
                options: .static([
                    MockPickableItem()
                ]),
                footerText: .static("groupFooter"),
                onPickedOption: { _, result in
                    result(.failure("failure"))
                }
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

        ChildPaneItem._assertInitProperties(
            childPaneItem,
            pickerGroups: groups,
            title: "title",
            value: "value",
            footerText: "footer",
            layoutType: .vertical(.autoGrow),
            fallbackString: "fallback",
            isPaneReloadable: true,
            isPaneSearchable: true,
            onPickedOptionFailure: "failure",
            testCase: self
        )
    }
}
