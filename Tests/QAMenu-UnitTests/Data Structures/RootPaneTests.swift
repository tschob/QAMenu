//
//  RootPaneTests.swift
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

class RootPaneTests: XCTestCase {

    var disposeBag = DisposeBag()

    override func setUpWithError() throws {
        self.disposeBag = DisposeBag()
    }

    func test_typeId() throws {
        XCTAssertEqual(RootPane.typeId, "RootPane")
    }

    func test_invalidate_doesNotCrash_whenNoObserverIsAdded() {
        let sut = RootPane(title: .static(""), items: [])

        sut.invalidate()

        XCTAssert(true, "invalidating without an observation doesn't crash")
    }

    func test_invalidate_firesOnInvalidationEvent() {
        let sut = RootPane(title: .static(""), items: [])

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

    func test_invalidate_sendsOnInvalidationSubject() {
        let sut = RootPane(title: .static(""), items: [])

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

    // MARK: - init

    func test_initWithItems_usesDefaultTitle() throws {
        let sut = RootPane(items: [])

        XCTAssertEqual(sut.title.unboxed, "QA Menu")
    }

    func test_initWithItems() throws {
        let title: Dynamic<String?> = .computed { "test" }
        let items = [
            MockItem(),
            MockItem(),
            MockItem()
        ]
        let isSearchable = true
        let sut = RootPane(title: title, items: items, isSearchable: isSearchable)

        XCTAssertEqual(sut.title.unboxed, title.unboxed)
        XCTAssertEqual(sut.groups.count, 1)
        XCTAssertEqual(sut.groups[0].items.unboxed as? [MockItem], items)
        XCTAssertEqual(sut.isSearchable, isSearchable)
    }

    func test_initWithItems_whenNotPassingIsSearchable_defaultsToFalse() throws {
        let sut = RootPane(title: .static(""), items: [])

        XCTAssertFalse(sut.isSearchable)
    }

    func test_initWithGroups_usesDefaultTitle() throws {
        let sut = RootPane(groups: [])

        XCTAssertEqual(sut.title.unboxed, "QA Menu")
    }

    func test_initWithGroups() throws {
        let title: Dynamic<String?> = .computed { "test" }
        let groups = [
            MockGroup(),
            MockGroup()
        ]
        let isSearchable = true
        let sut = RootPane(title: title, groups: groups, isSearchable: isSearchable)

        XCTAssertEqual(sut.title.unboxed, title.unboxed)
        XCTAssertEqual(sut.groups.count, 2)
        XCTAssertEqual(sut.groups as! [MockGroup], groups)
        XCTAssertEqual(sut.isSearchable, isSearchable)
    }

    func test_initWithGroups_whenNotPassingIsSearchable_defaultsToFalse() throws {
        let sut = Pane(title: .static(""), groups: [])

        XCTAssertFalse(sut.isSearchable)
    }
}
