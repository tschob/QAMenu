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

    func test_group_asPane_whenHavingNoItems_returnsEmptyPane() throws {
        let sut = ItemGroup(items: [])

        let pane = sut.asPane(title: .static("Pane"))

        assert_pane(
            pane,
            matches: [sut],
            title: "Pane",
            groupTitles: [nil],
            isSearchable: nil
        )
    }

    func test_group_asPane_whenUsingNilTitle_returnsPaneWithNilTitle() throws {
        let sut = ItemGroup(title: .static("ItemGroup"), items: [MockItem(), MockItem()])

        let pane = sut.asPane(title: .static(nil))

        assert_pane(
            pane,
            matches: [sut],
            title: nil,
            groupTitles: ["ItemGroup"],
            isSearchable: nil
        )
    }

    func test_group_asPane_whenUsingNoTitle_returnsPaneWithGroupTitle() throws {
        let sut = ItemGroup(title: .static("ItemGroup"), items: [MockItem(), MockItem()])

        let pane = sut.asPane()

        assert_pane(
            pane,
            matches: [sut],
            title: "ItemGroup",
            groupTitles: [nil],
            isSearchable: nil
        )
    }

    func test_group_asPane_whenUsingNoTitleAndGroupTitleIsNil_returnsPaneWithEmptyTitle() throws {
        let sut = ItemGroup(items: [MockItem(), MockItem()])

        let pane = sut.asPane()

        assert_pane(
            pane,
            matches: [sut],
            title: "",
            groupTitles: [nil],
            isSearchable: nil
        )
    }

    func test_group_asPane_whenProvidingTitle_returnsPane() throws {
        let sut = ItemGroup(title: .static("ItemGroup"), items: [MockItem(), MockItem()])

        let pane = sut.asPane(title: .static("Pane"))

        assert_pane(
            pane,
            matches: [sut],
            title: "Pane",
            groupTitles: ["ItemGroup"],
            isSearchable: nil
        )
    }

    func test_group_asPane_whenUsingNoTitleAndProvidingIsSearchable_returnsPane() throws {
        let sut = ItemGroup(title: .static("ItemGroup"), items: [MockItem(), MockItem()])

        let pane = sut.asPane(isSearchable: true)

        assert_pane(
            pane,
            matches: [sut],
            title: "ItemGroup",
            groupTitles: [nil],
            isSearchable: true
        )
    }

    func test_group_asPane_whenUsingNilTitleAndProvidingIsSearchable_returnsPane() throws {
        let sut = ItemGroup(title: .static("ItemGroup"), items: [MockItem(), MockItem()])

        let pane = sut.asPane(title: .static(nil), isSearchable: true)

        assert_pane(
            pane,
            matches: [sut],
            title: nil,
            groupTitles: ["ItemGroup"],
            isSearchable: true
        )
    }

    func test_group_asPane_whenProvidingTitleAndIsSearchable_returnsPane() throws {
        let sut = ItemGroup(title: .static("ItemGroup"), items: [MockItem(), MockItem()])

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

    func test_groups_asPane_whenHavingNoItems_returnsEmptyPane() throws {
        let sut = [
            ItemGroup(title: .static("ItemGroup1"), items: [])
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

    func test_groups_asPane_whenUsingNilTitle_returnsPaneWithNilTitle() throws {
        let sut = [
            ItemGroup(title: .static("ItemGroup1"), items: [
                MockItem(),
                MockItem()
            ]),
            ItemGroup(title: .static(nil), items: [
                MockItem()
            ])
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

    func test_groups_asPane_whenProvidingTitle_returnsPane() throws {
        let sut = [
            ItemGroup(title: .static("ItemGroup1"), items: [
                MockItem(),
                MockItem()
            ]),
            ItemGroup(items: [
                MockItem()
            ])
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

    func test_groups_asPane_whenUsingNilTitleAndProvidingIsSearchable_returnsPane() throws {
        let sut = [
            ItemGroup(title: .static("ItemGroup1"), items: [
                MockItem(),
                MockItem()
            ]),
            ItemGroup(items: [
                MockItem()
            ])
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

    func test_groups_asPane_whenProvidingTitleAndIsSearchable_returnsPane() throws {
        let sut = [
            ItemGroup(title: .static("ItemGroup1"), items: [
                MockItem(),
                MockItem()
            ]),
            ItemGroup(items: [
                MockItem()
            ])
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

    func test_group_asChildPaneItem_whenHavingNoItems_returnsEmptyChildPaneItem() throws {
        let sut = ItemGroup(title: .static("ItemGroup"), items: [])

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

    func test_group_asChildPaneItem_whenUsingNoTitle_returnsChildPaneItemWitGroupTitle() throws {
        let sut = ItemGroup(title: .static("ItemGroup"), items: [MockItem(), MockItem()])

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

    func test_group_asChildPaneItem_whenUsingNilTitle_returnsChildPaneItem() throws {
        let sut = ItemGroup(title: .static("ItemGroup"), items: [MockItem(), MockItem()])

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

    func test_group_asChildPaneItem_whenProvidingTitle_returnsChildPaneItem() throws {
        let sut = ItemGroup(title: .static("ItemGroup"), items: [MockItem(), MockItem()])

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

    func test_group_asChildPaneItem_whenProvidingTitleAndFooterAndIsSearchable_returnsChildPaneItem() throws {
        let sut = ItemGroup(title: .static("ItemGroup"), items: [MockItem(), MockItem()])

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

    func test_groups_asChildPaneItem_whenHavingNoItems_returnsEmptyChildPaneItem() throws {
        let sut = [
            ItemGroup(title: .static("ItemGroup1"), items: [])
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

    func test_groups_asChildPaneItem_whenUsingNilTitle_returnsChildPaneItem() throws {
        let sut = [
            ItemGroup(title: .static("ItemGroup1"), items: [
                MockItem(),
                MockItem()
            ]),
            ItemGroup(items: [
                MockItem()
            ])
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

    func test_groups_asChildPaneItem_whenProvidingTitle_returnsChildPaneItem() throws {
        let sut = [
            ItemGroup(title: .static("ItemGroup1"), items: [
                MockItem(),
                MockItem()
            ]),
            ItemGroup(items: [
                MockItem()
            ])
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

    func test_groups_asChildPaneItem_whenProvidingTitleAndFooterAndIsSearchable_returnsChildPaneItem() throws {
        let sut = [
            ItemGroup(title: .static("ItemGroup1"), items: [
                MockItem(),
                MockItem()
            ]),
            ItemGroup(items: [
                MockItem()
            ])
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
        matches suts: [ItemGroup],
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
                XCTAssertEqual(group.items[itemIndex] as! MockItem, item as! MockItem, file: file, line: line)
                itemIndex += 1
            }
            groupIndex += 1
        }
    }

    private func assert_childPaneItem(
        _ childPaneItem: ChildPaneItem,
        matches suts: [ItemGroup],
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
                XCTAssertEqual(group.items[itemIndex] as! MockItem, item as! MockItem, file: file, line: line)
                itemIndex += 1
            }
            groupIndex += 1
        }
    }
}
