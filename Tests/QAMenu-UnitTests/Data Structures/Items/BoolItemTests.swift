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

    var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        self.disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        self.disposeBag = nil
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

    func test_init_whenPassingOnlyMandatoryParameters() throws {
        let sut = BoolItem(
            title: .static("title"),
            value: .static(false),
            onValueChange: { _, _, result in
                result(.failure("failure"))
            }
        )

        BoolItem._assertInitProperties(
            sut,
            title: "title",
            value: false,
            onValueChangeFailure: "failure",
            testCase: self
        )
    }

    func test_init_whenPassingAllParameters() throws {
        let sut = BoolItem(
            title: .static("title"),
            value: .static(true),
            footerText: .static("footer"),
            onValueChange: { _, _, result in
                result(.failure("failure"))
            }
        )

        BoolItem._assertInitProperties(
            sut,
            title: "title",
            value: true,
            footerText: "footer",
            onValueChangeFailure: "failure",
            testCase: self
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
}
