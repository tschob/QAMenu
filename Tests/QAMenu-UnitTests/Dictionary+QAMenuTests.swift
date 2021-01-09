//
//  Dictionary+QAMenuTests.swift
//
//  Created by Hans Seiffert on 15.11.20.
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

class Dictionary_QAMenuTests: XCTestCase {

    let dictionary = [
        "a": 0,
        "c": 1,
        "d": 2,
        "b": 3,
        "e": nil
    ]

    let dictionaryWithoutOptionals: [String: Any] = [
        "0": "0",
        "1": "1",
        "3": 3,
        "2": 2
    ]

    func test_dm_toStringItems_whenNoLayoutGiven_usesVerticalAutoGrow() throws {
        let sut = dictionary.dm_toStringItems()

        XCTAssertEqual(sut.filter({ $0.layoutType() == .vertical(.autoGrow) }).count, self.dictionary.count)
    }

    func test_dm_toStringItems_usesGivenLayout() throws {
        let sut = dictionary.dm_toStringItems(layoutType: .static(.horizontal(.singleLine)))

        XCTAssertEqual(sut.filter({ $0.layoutType() == .horizontal(.singleLine) }).count, self.dictionary.count)
    }

    func test_dm_toStringItems_whenHavingOptionals_containsAllValues() throws {
        let sut = dictionary.dm_toStringItems()

        XCTAssert(sut.contains(where: { $0.title?.unboxed == "a" && $0.value?.unboxed == "0" }))
        XCTAssert(sut.contains(where: { $0.title?.unboxed == "c" && $0.value?.unboxed == "1" }))
        XCTAssert(sut.contains(where: { $0.title?.unboxed == "d" && $0.value?.unboxed == "2" }))
        XCTAssert(sut.contains(where: { $0.title?.unboxed == "b" && $0.value?.unboxed == "3" }))
        XCTAssert(sut.contains(where: { $0.title?.unboxed == "e" && $0.value?.unboxed == nil }))
    }

    func test_dm_toStringItems_whenHavingOptionalsAndDisablingOptionalFormatting_containsAllValues() throws {
        let sut = dictionary.dm_toStringItems(removeOptionalsIdentificationFromString: false)

        XCTAssert(sut.contains(where: { $0.title?.unboxed == "a" && $0.value?.unboxed == "Optional(0)" }))
        XCTAssert(sut.contains(where: { $0.title?.unboxed == "c" && $0.value?.unboxed == "Optional(1)" }))
        XCTAssert(sut.contains(where: { $0.title?.unboxed == "d" && $0.value?.unboxed == "Optional(2)" }))
        XCTAssert(sut.contains(where: { $0.title?.unboxed == "b" && $0.value?.unboxed == "Optional(3)" }))
        XCTAssert(sut.contains(where: { $0.title?.unboxed == "e" && $0.value?.unboxed == "nil" }))
    }

    func test_dm_toStringItems_whenHavingMixedDataTypes_containsAllValues() throws {
        let sut = dictionaryWithoutOptionals.dm_toStringItems()

        XCTAssert(sut.contains(where: { $0.title?.unboxed == "0" && $0.value?.unboxed == "0" }))
        XCTAssert(sut.contains(where: { $0.title?.unboxed == "1" && $0.value?.unboxed == "1" }))
        XCTAssert(sut.contains(where: { $0.title?.unboxed == "3" && $0.value?.unboxed == "3" }))
        XCTAssert(sut.contains(where: { $0.title?.unboxed == "2" && $0.value?.unboxed == "2" }))
    }

    func test_dm_toStringItems_whenHavingMixedDataTypesAndDisablingOptionalFormatting_containsAllValues() throws {
        let sut = dictionaryWithoutOptionals.dm_toStringItems(removeOptionalsIdentificationFromString: false)

        XCTAssert(sut.contains(where: { $0.title?.unboxed == "0" && $0.value?.unboxed == "0" }))
        XCTAssert(sut.contains(where: { $0.title?.unboxed == "1" && $0.value?.unboxed == "1" }))
        XCTAssert(sut.contains(where: { $0.title?.unboxed == "3" && $0.value?.unboxed == "3" }))
        XCTAssert(sut.contains(where: { $0.title?.unboxed == "2" && $0.value?.unboxed == "2" }))
    }
}
