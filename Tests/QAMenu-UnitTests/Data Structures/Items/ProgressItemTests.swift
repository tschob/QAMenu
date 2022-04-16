//
//  ProgressItemTests.swift
//
//  Created by Hans Seiffert on 22.02.21.
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
@testable import QAMenu

class ProgressItemTests: XCTestCase {

    var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        self.disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        self.disposeBag = nil
    }

    func test_typeId() throws {
        XCTAssertEqual(ProgressItem.typeId, "ProgressItem")
    }

    // MARK: - Invalidatable

    func test_invalidate_doesNotCrash_whenNoObserverIsAdded() {
        let sut = ProgressItem()

        sut.invalidate()

        XCTAssert(true, "invalidating without an observation doesn't crash")
    }

    func test_invalidate_firesOnInvalidationEvent() {
        let sut = ProgressItem()

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

    @available(iOS 13.0, *)
    func test_invalidate_sendsOnInvalidationSubject() {
        let sut = ProgressItem()

        let invalidationExpectation = expectation(description: "onInvalidationSubject sent")
        invalidationExpectation.assertForOverFulfill = true
        let cancellable = sut.onInvalidationSubject
            .sink(receiveValue: {
                invalidationExpectation.fulfill()
            })

        sut.invalidate()

        wait(for: [invalidationExpectation], timeout: 0.01)
        cancellable.cancel()
    }

    // MARK: - State

    func test_whenUpdatingState_firesOnInvalidationEvent() {
        let sut = ProgressItem()

        let invalidationExpectation = expectation(description: "onInvalidation fires")
        invalidationExpectation.assertForOverFulfill = true
        sut.onInvalidation
            .observe {
                invalidationExpectation.fulfill()
            }
            .disposeWith(self.disposeBag)

        sut.state = .progress("progress")

        wait(for: [invalidationExpectation], timeout: 0.01)
    }

    // MARK: - Searchable

    func test_searchableContent_whenStateIsIdle_isEmpty() throws {
        let sut = ProgressItem()

        let searchableContent = sut.searchableContent.compactMap { $0 }
        XCTAssertTrue(searchableContent.isEmpty)
    }

    func test_searchableContent_whenStateIsIdle_andFooter_containsOnlyFooter() throws {
        let sut = ProgressItem(footerText: .static("footer"))

        let searchableContent = sut.searchableContent.compactMap { $0 }
        XCTAssertEqual(searchableContent.count, 1)
        XCTAssertTrue(searchableContent.contains("footer"))
    }

    func test_searchableContent_whenStateIsProgress_andFooter_containsOnlyFooter() throws {
        let sut = ProgressItem(state: .progress("progress"), footerText: .static("footer"))

        let searchableContent = sut.searchableContent.compactMap { $0 }
        XCTAssertEqual(searchableContent.count, 2)
        XCTAssertTrue(searchableContent.contains("progress"))
        XCTAssertTrue(searchableContent.contains("footer"))
    }

    func test_searchableContent_whenStateIsNilProgress_andFooter_containsOnlyFooter() throws {
        let sut = ProgressItem(state: .progress(nil), footerText: .static("footer"))

        let searchableContent = sut.searchableContent.compactMap { $0 }
        XCTAssertEqual(searchableContent.count, 1)
        XCTAssertTrue(searchableContent.contains("footer"))
    }

    func test_searchableContent_whenStateIsSuccess_andFooter_containsOnlyFooter() throws {
        let sut = ProgressItem(state: .success("success"), footerText: .static("footer"))

        let searchableContent = sut.searchableContent.compactMap { $0 }
        XCTAssertEqual(searchableContent.count, 2)
        XCTAssertTrue(searchableContent.contains("success"))
        XCTAssertTrue(searchableContent.contains("footer"))
    }

    func test_searchableContent_whenStateIsFailure_andFooter_containsOnlyFooter() throws {
        let sut = ProgressItem(state: .failure("failure"), footerText: .static("footer"))

        let searchableContent = sut.searchableContent.compactMap { $0 }
        XCTAssertEqual(searchableContent.count, 2)
        XCTAssertTrue(searchableContent.contains("failure"))
        XCTAssertTrue(searchableContent.contains("footer"))
    }
}
