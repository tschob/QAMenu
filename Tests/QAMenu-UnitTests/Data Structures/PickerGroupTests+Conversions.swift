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

    func test_pickerGroup_asPane_whenHavingNoItems_returnsEmptyPane() throws {
        let options: [MockPickableItem] = []
        let sut = PickerGroup(
            title: .static(nil),
            options: options,
            onPickedOption: { _, _ in }
        )

        let pane = sut.asPane(title: .static("Pane"))

        assert_pane(
            pane,
            matches: [sut],
            title: "Pane",
            groupTitles: [nil],
            isSearchable: nil
        )
    }

    func test_pickerGroup_asPane_whenUsingNilTitle_returnsPaneWithNilTitle() throws {
        let options: [MockPickableItem] = [
            MockPickableItem()
        ]
        let sut = PickerGroup(
            title: .static("ItemGroup"),
            options: options,
            onPickedOption: { _, _ in }
        )

        let pane = sut.asPane(title: .static(nil))

        assert_pane(
            pane,
            matches: [sut],
            title: nil,
            groupTitles: ["ItemGroup"],
            isSearchable: nil
        )
    }

    func test_pickerGroup_asPane_whenUsingNoTitle_returnsPaneWithGroupTitle() throws {
        let options: [MockPickableItem] = [
            MockPickableItem()
        ]
        let sut = PickerGroup(
            title: .static("ItemGroup"),
            options: options,
            onPickedOption: { _, _ in }
        )

        let pane = sut.asPane()

        assert_pane(
            pane,
            matches: [sut],
            title: "ItemGroup",
            groupTitles: [nil],
            isSearchable: nil
        )
    }

    func test_pickerGroup_asPane_whenUsingNoTitleAndGroupTitleIsNil_returnsPaneWithEmptyTitle() throws {
        let options: [MockPickableItem] = [
            MockPickableItem()
        ]
        let sut = PickerGroup(
            options: options,
            onPickedOption: { _, _ in }
        )

        let pane = sut.asPane()

        assert_pane(
            pane,
            matches: [sut],
            title: "",
            groupTitles: [nil],
            isSearchable: nil
        )
    }

    func test_pickerGroup_asPane_whenProvidingTitle_returnsPane() throws {
        let options: [MockPickableItem] = [
            MockPickableItem(),
            MockPickableItem()
        ]
        let sut = PickerGroup(
            title: .static("ItemGroup"),
            options: options,
            onPickedOption: { _, _ in }
        )

        let pane = sut.asPane(title: .static("Pane"))

        assert_pane(
            pane,
            matches: [sut],
            title: "Pane",
            groupTitles: ["ItemGroup"],
            isSearchable: nil
        )
    }

    func test_pickerGroup_asPane_whenUsingNoTitleAndProvidingIsSearchable_returnsPane() throws {
        let options: [MockPickableItem] = [
            MockPickableItem()
        ]
        let sut = PickerGroup(
            title: .static("ItemGroup"),
            options: options,
            onPickedOption: { _, _ in }
        )

        let pane = sut.asPane(isSearchable: true)

        assert_pane(
            pane,
            matches: [sut],
            title: "ItemGroup",
            groupTitles: [nil],
            isSearchable: true
        )
    }

    func test_pickerGroup_asPane_whenUsingNilTitleAndProvidingIsSearchable_returnsPane() throws {
        let options: [MockPickableItem] = [
            MockPickableItem()
        ]
        let sut = PickerGroup(
            title: .static("ItemGroup"),
            options: options,
            onPickedOption: { _, _ in }
        )

        let pane = sut.asPane(title: .static(nil), isSearchable: true)

        assert_pane(
            pane,
            matches: [sut],
            title: nil,
            groupTitles: ["ItemGroup"],
            isSearchable: true
        )
    }

    func test_pickerGroup_asPane_whenProvidingTitleAndIsSearchable_returnsPane() throws {
        let options: [MockPickableItem] = [
            MockPickableItem()
        ]
        let sut = PickerGroup(
            title: .static("ItemGroup"),
            options: options,
            onPickedOption: { _, _ in }
        )

        let pane = sut.asPane(title: .static("Pane"), isSearchable: true)

        assert_pane(
            pane,
            matches: [sut],
            title: "Pane",
            groupTitles: ["ItemGroup"],
            isSearchable: true
        )
    }

    // MARK: - asPane (Array)

    func test_pickerGroups_asPane_whenHavingNoItems_returnsEmptyPane() throws {
        let options: [MockPickableItem] = []
        let sut = [
            PickerGroup(
                title: .static("ItemGroup1"),
                options: options,
                onPickedOption: { _, _ in }
            )
        ]

        let pane = sut.asPane(title: .static("Pane"))

        assert_pane(
            pane,
            matches: sut,
            title: "Pane",
            groupTitles: ["ItemGroup1"],
            isSearchable: nil
        )
    }

    func test_pickerGroups_asPane_whenUsingNilTitle_returnsPaneWithNilTitle() throws {
        let options: [MockPickableItem] = [
            MockPickableItem(),
            MockPickableItem()
        ]
        let sut = [
            PickerGroup(
                title: .static("ItemGroup1"),
                options: options,
                onPickedOption: { _, _ in }
            ),
            PickerGroup(
                options: [],
                onPickedOption: { _, _ in }
            )
        ]

        let pane = sut.asPane(title: .static(nil))

        assert_pane(
            pane,
            matches: sut,
            title: nil,
            groupTitles: ["ItemGroup1", nil],
            isSearchable: nil
        )
    }

    func test_pickerGroups_asPane_whenProvidingTitle_returnsPane() throws {
        let options: [MockPickableItem] = [
            MockPickableItem(),
            MockPickableItem()
        ]
        let sut = [
            PickerGroup(
                title: .static("ItemGroup1"),
                options: options,
                onPickedOption: { _, _ in }
            ),
            PickerGroup(
                title: .static(nil),
                options: [],
                onPickedOption: { _, _ in }
            )
        ]

        let pane = sut.asPane(title: .static("Pane"))

        assert_pane(
            pane,
            matches: sut,
            title: "Pane",
            groupTitles: ["ItemGroup1", nil],
            isSearchable: nil
        )
    }

    func test_pickerGroups_asPane_whenUsingNilTitleAndProvidingIsSearchable_returnsPane() throws {
        let options: [MockPickableItem] = [
            MockPickableItem(),
            MockPickableItem()
        ]
        let sut = [
            PickerGroup(
                title: .static("ItemGroup1"),
                options: options,
                onPickedOption: { _, _ in }
            ),
            PickerGroup(
                options: [],
                onPickedOption: { _, _ in }
            )
        ]

        let pane = sut.asPane(title: .static(nil), isSearchable: true)

        assert_pane(
            pane,
            matches: sut,
            title: nil,
            groupTitles: ["ItemGroup1", nil],
            isSearchable: true
        )
    }

    func test_pickerGroups_asPane_whenProvidingTitleAndIsSearchable_returnsPane() throws {
        let options: [MockPickableItem] = [
            MockPickableItem(),
            MockPickableItem()
        ]
        let sut = [
            PickerGroup(
                title: .static("ItemGroup1"),
                options: options,
                onPickedOption: { _, _ in }
            ),
            PickerGroup(
                options: [],
                onPickedOption: { _, _ in }
            )
        ]

        let pane = sut.asPane(title: .static("Pane"), isSearchable: true)

        assert_pane(
            pane,
            matches: sut,
            title: "Pane",
            groupTitles: ["ItemGroup1", nil],
            isSearchable: true
        )
    }

    // MARK: - asChildPaneItem

    func test_pickerGroup_asChildPaneItem_whenHavingNoItems_returnsEmptyChildPaneItem() throws {
        let options: [MockPickableItem] = []
        let sut = PickerGroup(
            title: .static("ItemGroup"),
            options: options,
            onPickedOption: { _, _ in }
        )

        let childPaneItem = sut.asChildPaneItem(title: .static("Pane"))

        assert_childPaneItem(
            childPaneItem,
            matches: [sut],
            title: "Pane",
            groupTitles: ["ItemGroup"],
            footerText: nil,
            isSearchable: nil
        )
    }

    func test_pickerGroup_asChildPaneItem_whenUsingNoTitle_returnsChildPaneItemWitGroupTitle() throws {
        let options: [MockPickableItem] = [
            MockPickableItem()
        ]
        let sut = PickerGroup(
            title: .static("ItemGroup"),
            options: options,
            onPickedOption: { _, _ in }
        )

        let childPaneItem = sut.asChildPaneItem()

        assert_childPaneItem(
            childPaneItem,
            matches: [sut],
            title: "ItemGroup",
            groupTitles: [nil],
            footerText: nil,
            isSearchable: nil
        )
    }

    func test_pickerGroup_asChildPaneItem_whenUsingNilTitle_returnsChildPaneItem() throws {
        let options: [MockPickableItem] = [
            MockPickableItem()
        ]
        let sut = PickerGroup(
            title: .static("ItemGroup"),
            options: options,
            onPickedOption: { _, _ in }
        )

        let childPaneItem = sut.asChildPaneItem(title: .static(nil))

        assert_childPaneItem(
            childPaneItem,
            matches: [sut],
            title: nil,
            groupTitles: ["ItemGroup"],
            footerText: nil,
            isSearchable: nil
        )
    }

    func test_pickerGroup_asChildPaneItem_whenProvidingTitle_returnsChildPaneItem() throws {
        let options: [MockPickableItem] = [
            MockPickableItem()
        ]
        let sut = PickerGroup(
            title: .static("ItemGroup"),
            options: options,
            onPickedOption: { _, _ in }
        )

        let childPaneItem = sut.asChildPaneItem(title: .static("Pane"))

        assert_childPaneItem(
            childPaneItem,
            matches: [sut],
            title: "Pane",
            groupTitles: ["ItemGroup"],
            footerText: nil,
            isSearchable: nil
        )
    }

    func test_pickerGroup_asChildPaneItem_whenProvidingTitleAndFooterAndIsSearchable_returnsChildPaneItem() throws {
        let options: [MockPickableItem] = [
            MockPickableItem()
        ]
        let sut = PickerGroup(
            title: .static("ItemGroup"),
            options: options,
            onPickedOption: { _, _ in }
        )

        let childPaneItem = sut.asChildPaneItem(
            title: .static("Pane"),
            footerText: .static("footer"),
            isSearchable: true
        )

        assert_childPaneItem(
            childPaneItem,
            matches: [sut],
            title: "Pane",
            groupTitles: ["ItemGroup"],
            footerText: "footer",
            isSearchable: true
        )
    }

    // MARK: - asChildPaneItem (Array)

    func test_pickerGroups_asChildPaneItem_whenHavingNoItems_returnsEmptyChildPaneItem() throws {
        let sut = [
            PickerGroup(
                title: .static("ItemGroup1"),
                options: [],
                onPickedOption: { _, _ in }
            )
        ]
        let childPaneItem = sut.asChildPaneItem(title: .static("Pane"))

        assert_childPaneItem(
            childPaneItem,
            matches: sut,
            title: "Pane",
            groupTitles: ["ItemGroup1"],
            footerText: nil,
            isSearchable: nil
        )
    }

    func test_pickerGroups_asChildPaneItem_whenUsingNilTitle_returnsChildPaneItem() throws {
        let options: [MockPickableItem] = [
            MockPickableItem(),
            MockPickableItem()
        ]
        let sut = [
            PickerGroup(
                title: .static("ItemGroup1"),
                options: options,
                onPickedOption: { _, _ in }
            ),
            PickerGroup(
                options: [],
                onPickedOption: { _, _ in }
            )
        ]

        let childPaneItem = sut.asChildPaneItem(title: .static(nil))

        assert_childPaneItem(
            childPaneItem,
            matches: sut,
            title: nil,
            groupTitles: ["ItemGroup1", nil],
            footerText: nil,
            isSearchable: nil
        )
    }

    func test_pickerGroups_asChildPaneItem_whenProvidingTitle_returnsChildPaneItem() throws {
        let options: [MockPickableItem] = [
            MockPickableItem(),
            MockPickableItem()
        ]
        let sut = [
            PickerGroup(
                title: .static("ItemGroup1"),
                options: options,
                onPickedOption: { _, _ in }
            ),
            PickerGroup(
                options: [],
                onPickedOption: { _, _ in }
            )
        ]

        let childPaneItem = sut.asChildPaneItem(title: .static("Pane"))

        assert_childPaneItem(
            childPaneItem,
            matches: sut,
            title: "Pane",
            groupTitles: ["ItemGroup1", nil],
            footerText: nil,
            isSearchable: nil
        )
    }

    func test_pickerGroups_asChildPaneItem_whenProvidingTitleAndFooterAndIsSearchable_returnsChildPaneItem() throws {
        let options: [MockPickableItem] = [
            MockPickableItem(),
            MockPickableItem()
        ]
        let sut = [
            PickerGroup(
                title: .static("ItemGroup1"),
                options: options,
                onPickedOption: { _, _ in }
            ),
            PickerGroup(
                options: [],
                onPickedOption: { _, _ in }
            )
        ]

        let childPaneItem = sut.asChildPaneItem(
            title: .static("Pane"),
            footerText: .static("footer"),
            isSearchable: true
        )

        assert_childPaneItem(
            childPaneItem,
            matches: sut,
            title: "Pane",
            groupTitles: ["ItemGroup1", nil],
            footerText: "footer",
            isSearchable: true
        )
    }

    // MARK: - Helper

    private func assert_pane(
        _ pane: Pane,
        matches suts: [PickerGroup],
        title: String?,
        groupTitles: [String?],
        isSearchable: Bool?,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        if let title = title {
            XCTAssertEqual(pane.title.unboxed, title, file: file, line: line)
        } else {
            XCTAssertEqual(pane.title.unboxed, nil, file: file, line: line)
        }
        if let isSearchable = isSearchable {
            XCTAssertEqual(pane.isSearchable, isSearchable, file: file, line: line)
        } else {
            XCTAssertEqual(pane.isSearchable, false, file: file, line: line)
        }
        XCTAssertEqual(pane.groups.count, suts.count, file: file, line: line)
        var groupIndex = 0
        suts.forEach { sut in
            let group = pane.groups[groupIndex]
            XCTAssertEqual(group.title?.unboxed, groupTitles[groupIndex], file: file, line: line)
            XCTAssertEqual(group.items.count, sut.items.count, file: file, line: line)
            var itemIndex = 0
            sut.items.forEach { item in
                XCTAssertEqual(group.items[itemIndex] as! MockPickableItem, item as! MockPickableItem, file: file, line: line)
                itemIndex += 1
            }
            groupIndex += 1
        }
    }

    private func assert_childPaneItem(
        _ childPaneItem: ChildPaneItem,
        matches suts: [PickerGroup],
        title: String?,
        groupTitles: [String?],
        footerText: String?,
        isSearchable: Bool?,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let pane: Pane! = {
            if case .pane(let paneClosure) = childPaneItem.childType {
                return paneClosure()
            } else {
                XCTFail("childPane should be of type .pane(...)")
                return nil
            }
        }()

        if let title = title {
            XCTAssertEqual(pane.title.unboxed, title, file: file, line: line)
        } else {
            XCTAssertEqual(pane.title.unboxed, nil, file: file, line: line)
        }
        if let footerText = footerText {
            XCTAssertEqual(childPaneItem.footerText?.unboxed, footerText, file: file, line: line)
        } else {
            XCTAssertNil(childPaneItem.footerText, file: file, line: line)
        }
        if let isSearchable = isSearchable {
            XCTAssertEqual(pane.isSearchable, isSearchable, file: file, line: line)
        } else {
            XCTAssertEqual(pane.isSearchable, false, file: file, line: line)
        }
        XCTAssertEqual(pane.groups.count, suts.count, file: file, line: line)
        var groupIndex = 0
        suts.forEach { sut in
            let group = pane.groups[groupIndex]
            XCTAssertEqual(group.title?.unboxed, groupTitles[groupIndex], file: file, line: line)
            XCTAssertEqual(group.items.count, sut.items.count, file: file, line: line)
            var itemIndex = 0
            sut.items.forEach { item in
                XCTAssertEqual(group.items[itemIndex] as! MockPickableItem, item as! MockPickableItem, file: file, line: line)
                itemIndex += 1
            }
            groupIndex += 1
        }
    }
}
