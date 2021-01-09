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

    // MARK: - asGroup

    func test_item_asGroup_whenOnlyUsingDefaultParameters_returnsGroup() throws {
        let sut = MockItem()

        let group = sut.asItemGroup()

        assert_group(group, matches: [sut], title: nil, footerText: nil)
    }

    func test_item_asGroup_whenProvidingTitle_returnsGroup() throws {
        let sut = MockItem()

        let group = sut.asItemGroup(title: .static("title"))

        assert_group(group, matches: [sut], title: "title", footerText: nil)
    }

    func test_item_asGroup_whenProvidingFooter_returnsGroup() throws {
        let sut = MockItem()

        let group = sut.asItemGroup(footerText: .static("footer"))

        assert_group(group, matches: [sut], title: nil, footerText: "footer")
    }

    func test_item_asGroup_whenProvidingTitleAndFooter_returnsGroup() throws {
        let sut = MockItem()

        let group = sut.asItemGroup(
            title: .static("title"),
            footerText: .static("footer")
        )

        assert_group(group, matches: [sut], title: "title", footerText: "footer")
    }

    // MARK: - asGroup (Array)

    func test_items_asGroup_whenHavingNoItems_returnsEmptyGroup() throws {
        let sut = [MockItem]()

        let group = sut.asItemGroup()

        assert_group(group, matches: sut, title: nil, footerText: nil)
    }

    func test_items_asGroup_whenOnlyUsingDefaultParameters_returnsGroup() throws {
        let sut = [
            MockItem(),
            MockItem()
        ]

        let group = sut.asItemGroup()

        assert_group(group, matches: sut, title: nil, footerText: nil)
    }

    func test_items_asGroup_whenProvidingTitle_returnsGroup() throws {
        let sut = [
            MockItem(),
            MockItem()
        ]

        let group = sut.asItemGroup(title: .static("title"))

        assert_group(group, matches: sut, title: "title", footerText: nil)
    }

    func test_items_asGroup_whenProvidingFooter_returnsGroup() throws {
        let sut = [
            MockItem(),
            MockItem()
        ]

        let group = sut.asItemGroup(footerText: .static("footer"))

        assert_group(group, matches: sut, title: nil, footerText: "footer")
    }

    func test_items_asGroup_whenProvidingTitleAndFooter_returnsGroup() throws {
        let sut = [
            MockItem(),
            MockItem()
        ]

        let group = sut.asItemGroup(
            title: .static("title"),
            footerText: .static("footer")
        )

        assert_group(group, matches: sut, title: "title", footerText: "footer")
    }

    // MARK: - asPane (Array)

    func test_items_asPane_whenHavingNoItems_returnsEmptyPane() throws {
        let sut = [MockItem]()

        let pane = sut.asPane(title: .static("empty"))

        assert_pane(pane, matches: sut, title: "empty", isSearchable: nil)
    }

    func test_items_asPane_whenUsingNilTitle_returnsPane() throws {
        let sut = [
            MockItem(),
            MockItem()
        ]

        let pane = sut.asPane(title: .static(nil))

        assert_pane(pane, matches: sut, title: nil, isSearchable: nil)
    }

    func test_items_asPane_whenProvidingTitle_returnsPane() throws {
        let sut = [
            MockItem(),
            MockItem()
        ]

        let pane = sut.asPane(title: .static("title"))

        assert_pane(pane, matches: sut, title: "title", isSearchable: nil)
    }

    func test_items_asPane_whenUsingNilTitleAndProvidingIsSearchable_returnsPane() throws {
        let sut = [
            MockItem(),
            MockItem()
        ]

        let pane = sut.asPane(title: .static(nil), isSearchable: true)

        assert_pane(pane, matches: sut, title: nil, isSearchable: true)
    }

    func test_items_asPane_whenProvidingTitleAndIsSearchable_returnsPane() throws {
        let sut = [
            MockItem(),
            MockItem()
        ]

        let pane = sut.asPane(
            title: .static("title"),
            isSearchable: false
        )

        assert_pane(pane, matches: sut, title: "title", isSearchable: false)
    }

    // MARK: - asChildPaneItem (Array)

    func test_items_asChildPaneItem_whenHavingNoItems_returnsEmptyChildPaneItem() throws {
        let sut = [MockItem]()

        let childPaneItem = sut.asChildPaneItem(title: .static("empty"))

        assert_childPaneItem(
            childPaneItem,
            matches: sut,
            title: "empty",
            footerText: nil,
            isSearchable: nil
        )
    }

    func test_items_asChildPaneItem_whenUsingNilTitle_returnsChildPaneItem() throws {
        let sut = [
            MockItem(),
            MockItem()
        ]

        let childPaneItem = sut.asChildPaneItem(title: .static(nil))

        assert_childPaneItem(
            childPaneItem,
            matches: sut,
            title: nil,
            footerText: nil,
            isSearchable: nil
        )
    }

    func test_items_asChildPaneItem_whenProvidingTitle_returnsChildPaneItem() throws {
        let sut = [
            MockItem(),
            MockItem()
        ]

        let childPaneItem = sut.asChildPaneItem(title: .static("title"))

        assert_childPaneItem(
            childPaneItem,
            matches: sut,
            title: "title",
            footerText: nil,
            isSearchable: nil
        )
    }

    func test_items_asChildPaneItem_whenUsingNilTitleAndFooter_returnsChildPaneItem() throws {
        let sut = [
            MockItem(),
            MockItem()
        ]

        let childPaneItem = sut.asChildPaneItem(title: .static(nil), footerText: .static("footer"))

        assert_childPaneItem(
            childPaneItem,
            matches: sut,
            title: nil,
            footerText: "footer",
            isSearchable: false
        )
    }

    func test_items_asChildPaneItem_whenProvidingTitleAndFooterAndIsSearchable_returnsChildPaneItem() throws {
        let sut = [
            MockItem(),
            MockItem()
        ]

        let childPaneItem = sut.asChildPaneItem(
            title: .static("title"),
            footerText: .static("footer"),
            isSearchable: true
        )

        assert_childPaneItem(
            childPaneItem,
            matches: sut,
            title: "title",
            footerText: "footer",
            isSearchable: true
        )
    }

    // MARK: - Helper

    private func assert_group(
        _ group: ItemGroup,
        matches sut: [MockItem],
        title: String?,
        footerText: String?,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        if let title = title {
            XCTAssertEqual(group.title?.unboxed, title, file: file, line: line)
        } else {
            XCTAssertNil(group.title, file: file, line: line)
        }
        if let footerText = footerText {
            XCTAssertEqual(group.footerText?.unboxed, footerText, file: file, line: line)
        } else {
            XCTAssertNil(group.footerText, file: file, line: line)
        }
        XCTAssertEqual(group.items.count, sut.count, file: file, line: line)
        var index = 0
        sut.forEach { item in
            XCTAssertEqual(group.items[index] as! MockItem, item, file: file, line: line)
            index += 1
        }
    }

    private func assert_pane(
        _ pane: Pane,
        matches sut: [MockItem],
        title: String?,
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
        XCTAssertEqual(pane.groups.count, 1, file: file, line: line)
        XCTAssertEqual(pane.groups[0].items.count, sut.count, file: file, line: line)
        var index = 0
        let group = pane.groups[0]
        sut.forEach { item in
            XCTAssertEqual(group.items[index] as! MockItem, item, file: file, line: line)
            index += 1
        }
    }

    private func assert_childPaneItem(
        _ childPaneItem: ChildPaneItem,
        matches sut: [MockItem],
        title: String?,
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
        XCTAssertEqual(pane.groups.count, 1, file: file, line: line)
        XCTAssertEqual(pane.groups[0].items.count, sut.count, file: file, line: line)
        var index = 0
        let group = pane.groups[0]
        sut.forEach { item in
            XCTAssertEqual(group.items[index] as! MockItem, item, file: file, line: line)
            index += 1
        }
    }
}
