//
//  SearcherTests.swift
//
//  Created by Hans Seiffert on 22.11.20.
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
@testable import QAMenuUIKit

class SearcherTests: XCTestCase {

    // MARK: - validatedQuery

    func test_validatedQuery_whenStringIsNil_returnsNil() throws {
        XCTAssertNil(Searcher.validatedQuery(from: nil))
    }

    func test_validatedQuery_whenStringIsEmpty_returnsNil() throws {
        XCTAssertNil(Searcher.validatedQuery(from: nil))
    }

    func test_validatedQuery_whenStringHasOneCharacter_returnsThem() throws {
        XCTAssertEqual(Searcher.validatedQuery(from: " "), " ")
    }

    func test_validatedQuery_whenStringHasMultipleCharacters_returnsThem() throws {
        XCTAssertEqual(Searcher.validatedQuery(from: "query string"), "query string")
    }

    // MARK: - filter

    func test_filter_whenGroupHasNoItems_NilQuery_returnsNoGroup() throws {
        XCTAssertEqual(Searcher.filter([], with: nil).count, 0)
    }

    func test_filter_whenGroupHasNoItems_withQuery_returnsEmptyGroup() throws {
        let resultGroups = Searcher.filter([], with: "query")

        XCTAssertEqual(resultGroups.count, 1)
        XCTAssertEqual(resultGroups[0].items.count, 0)
    }

    func test_filter_whenGroupHasNoMatchingItem_withNilQuery_returnsOriginalGroup() throws {
        let items: [MockItem] = [
            MockItem()
        ]
        let given: [MockGroup] = [
            MockGroup(items: items)
        ]
        let expected: [Group] = [
            MockGroup(items: items)
        ]

        let resultGroups = Searcher.filter(given, with: nil)

        assert_groups(resultGroups, matches: expected)
    }

    func test_filter_whenMultipleGroupsHaveNoMatchingItem_withNilQuery_returnsOriginalGroups() throws {
        let items: [MockItem] = [
            MockItem(),
            MockItem()
        ]
        let given: [MockGroup] = [
            MockGroup(items: items),
            MockGroup(items: items)
        ]
        let expected: [Group] = [
            MockGroup(items: items),
            MockGroup(items: items)
        ]

        let resultGroups = Searcher.filter(given, with: nil)

        assert_groups(resultGroups, matches: expected)
    }

    func test_filter_whenGroupHasNoMatchingItem_withQuery_returnsEmptyGroup() throws {
        let items: [MockItem] = [
            MockItem()
        ]
        let given: [MockGroup] = [
            MockGroup(items: items)
        ]
        let expected: [Group] = [
            ItemGroup(items: [])
        ]

        let resultGroups = Searcher.filter(given, with: "query")

        assert_groups(resultGroups, matches: expected)
    }

    func test_filter_whenGroupHasOneMatchingItem_withQuery_returnsGroup() throws {
        let items: [MockItem] = [
            MockItem(searchableContent: ["query"])
        ]
        let given: [MockGroup] = [
            MockGroup(items: items)
        ]
        let expected: [Group] = [
            ItemGroup(items: items)
        ]

        let resultGroups = Searcher.filter(given, with: "query")

        assert_groups(resultGroups, matches: expected)
    }

    func test_filter_whenGroupHasOneMatchingItemInMany_withQuery_returnsGroup() throws {
        let items: [MockItem] = [
            MockItem(searchableContent: ["query"]),
            MockItem(searchableContent: [])
        ]
        let given: [MockGroup] = [
            MockGroup(items: items)
        ]
        let expected: [Group] = [
            ItemGroup(items: [items[0]])
        ]

        let resultGroups = Searcher.filter(given, with: "query")

        assert_groups(resultGroups, matches: expected)
    }

    func test_filter_whenGroupHasMultipleMatchingItems_withQuery_returnsGroup() throws {
        let items: [MockItem] = [
            MockItem(searchableContent: ["query"]),
            MockItem(searchableContent: ["query"])
        ]
        let given: [MockGroup] = [
            MockGroup(items: items)
        ]
        let expected: [Group] = [
            ItemGroup(items: items)
        ]

        let resultGroups = Searcher.filter(given, with: "query")

        assert_groups(resultGroups, matches: expected)
    }

    func test_filter_whenMultipleGroupsWithOneHavingMultipleMatchingItems_withQuery_returnsGroup() throws {
        let items1: [MockItem] = [
            MockItem(searchableContent: ["query"]),
            MockItem(searchableContent: ["query"])
        ]
        let items2: [MockItem] = [
            MockItem()
        ]
        let given: [MockGroup] = [
            MockGroup(items: items1),
            MockGroup(items: items2)
        ]
        let expected: [Group] = [
            ItemGroup(items: items1)
        ]

        let resultGroups = Searcher.filter(given, with: "query")

        assert_groups(resultGroups, matches: expected)
    }

    func test_filter_whenMultipleGroupsHaveMultipleMatchingItems_withQuery_returnsGroups() throws {
        let items1: [MockItem] = [
            MockItem(searchableContent: ["query"]),
            MockItem(searchableContent: ["query"])
        ]
        let items2: [MockItem] = [
            MockItem(searchableContent: ["query"]),
            MockItem(searchableContent: ["query"])
        ]
        let given: [MockGroup] = [
            MockGroup(items: items1),
            MockGroup(items: items2)
        ]
        let expected: [Group] = [
            ItemGroup(items: items1 + items2)
        ]

        let resultGroups = Searcher.filter(given, with: "query")

        assert_groups(resultGroups, matches: expected)
    }

    // MARK: - Helper

    private func assert_groups(
        _ groups: [Group],
        matches expectedGroup: [Group],
        file: StaticString = #file,
        line: UInt = #line
    ) {
        XCTAssertEqual(groups.count, expectedGroup.count, file: file, line: line)
        var groupIndex = 0
        expectedGroup.forEach { expectedGroup in
            let group = groups[groupIndex]
            XCTAssertEqual(expectedGroup.items.count, group.items.count, file: file, line: line)
            var itemIndex = 0
            expectedGroup.items.forEach { item in
                XCTAssertTrue(item === group.items[itemIndex], file: file, line: line)
                itemIndex += 1
            }
            groupIndex += 1
        }
    }
}
