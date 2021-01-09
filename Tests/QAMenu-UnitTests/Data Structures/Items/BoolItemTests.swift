//
//  BoolItemTests.swift
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

class BoolItemTests: XCTestCase {

    var disposeBag = DisposeBag()

    override func setUpWithError() throws {
        self.disposeBag = DisposeBag()
    }

    func test_typeId() throws {
        XCTAssertEqual(BoolItem.typeId, "BoolItem")
    }

    func test_invalidate_doesNotCrash_whenNoObserverIsAdded() {
        let sut = BoolItem(
            title: .static("title"),
            value: .static(true),
            onValueChange: { _, _, _ in }
        )

        sut.invalidate()

        XCTAssert(true, "invalidating without an observation doesn't crash")
    }

    func test_invalidate_firesOnInvalidationEvent() {
        let sut = BoolItem(
            title: .static("title"),
            value: .static(false),
            onValueChange: { _, _, _ in }
        )
        let invalidationExpectation = expectation(description: "onInvalidation fires")
        invalidationExpectation.assertForOverFulfill = true
        sut.onInvalidation
            .observe {
                invalidationExpectation.fulfill()
            }
            .disposeWith(self.disposeBag)

        sut.invalidate()

        wait(for: [invalidationExpectation], timeout: 0.01)
    }

    // MARK: - init

    func test_init_whenPassingTitleAndValue() throws {
        let sut = BoolItem(
            title: .static("title"),
            value: .static(true),
            onValueChange: { _, _, result in
                result(.failure("test1"))
            }
        )

        assert_boolItem(
            sut,
            title: "title",
            value: true,
            footerText: nil,
            onValueChangeFailure: "test1"
        )
    }

    func test_init_whenPassingTitleAndValueAndFooter() throws {
        let sut = BoolItem(
            title: .static("title"),
            value: .static(false),
            onValueChange: { _, _, result in
                result(.failure("test2"))
            }
        )

        assert_boolItem(
            sut,
            title: "title",
            value: false,
            footerText: nil,
            onValueChangeFailure: "test2"
        )
    }

    func test_init_whenPassingTitleNilValueAndNilFooter() throws {
        let sut = BoolItem(
            title: .static("title"),
            value: .static(true),
            footerText: .static("footer"),
            onValueChange: { _, _, result in
                result(.failure("test3"))
            }
        )

        assert_boolItem(
            sut,
            title: "title",
            value: true,
            footerText: "footer",
            onValueChangeFailure: "test3"
        )
    }

    // MARK: - Searchable

    func test_searchableContent_whenHavingTitleAndValue_containsBoth() throws {
        let sut = BoolItem(
            title: .static("title"),
            value: .static(true),
            onValueChange: { _, _, _ in }
        )

        let searchableContent = sut.searchableContent.compactMap { $0 }
        XCTAssertEqual(searchableContent.count, 2)
        XCTAssertTrue(searchableContent.contains("title"))
        XCTAssertTrue(searchableContent.contains("true"))
    }

    func test_searchableContent_whenHavingTitleAndValueAndFooter_containsAllThree() throws {
        let sut = BoolItem(
            title: .static("title"),
            value: .static(false),
            footerText: .static("footer"),
            onValueChange: { _, _, _ in }
        )

        let searchableContent = sut.searchableContent.compactMap { $0 }
        XCTAssertEqual(searchableContent.count, 3)
        XCTAssertTrue(searchableContent.contains("title"))
        XCTAssertTrue(searchableContent.contains("false"))
        XCTAssertTrue(searchableContent.contains("footer"))
    }

    // MARK: - Helper

    private func assert_boolItem(
        _ sut: BoolItem,
        title: String,
        value: Bool,
        footerText: String?,
        onValueChangeFailure: String,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        XCTAssertEqual(sut.title.unboxed, title, file: file, line: line)
        XCTAssertEqual(sut.value.unboxed, value, file: file, line: line)
        XCTAssertEqual(sut.footerText?.unboxed, footerText, file: file, line: line)
        let resultExpectation = expectation(description: "")
        resultExpectation.assertForOverFulfill = true
        sut.onValueChange(true, sut) { result in
            if case .failure(let message) = result, message == onValueChangeFailure {
                resultExpectation.fulfill()
            } else {
                XCTFail("\(result) doesn't match .failure(\"\(onValueChangeFailure)\"")
            }
        }
        wait(for: [resultExpectation], timeout: 0.01)
    }
}
