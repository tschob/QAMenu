//
//  PickableItemTests.swift
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
@testable import QAMenu

class PickableItemTests: XCTestCase {

    var disposeBag = DisposeBag()

    override func setUpWithError() throws {
        self.disposeBag = DisposeBag()
    }

    func test_typeId() throws {
        XCTAssertEqual(PickableItem.typeId, "PickableItem")
    }

    func test_searchableContent_isEmptyForBaseClass() throws {
        let sut = PickableItem(
            identifier: .static("id"),
            isSelected: .static(true)
        )

        XCTAssertTrue(sut.searchableContent[0] == nil)
    }

    // MARK: - Invalidatable

    func test_invalidate_doesNotCrash_whenNoObserverIsAdded() {
        let sut = PickableItem(
            identifier: .static("id"),
            isSelected: .static(true)
        )

        sut.invalidate()

        XCTAssert(true, "invalidating without an observation doesn't crash")
    }

    func test_invalidate_firesOnInvalidationEvent() {
        let sut = PickableItem(
            identifier: .static("id"),
            isSelected: .static(true)
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

    @available(iOS 13.0, *)
    func test_invalidate_sendsOnInvalidationSubject() {
        let sut = PickableItem(
            identifier: .static("id"),
            isSelected: .static(true)
        )

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

    // MARK: - Selectable

    func test_isSelectable_whenNotSelected_returnsTrue() throws {
        let sut = PickableItem(
            identifier: .static("id"),
            isSelected: .static(false)
        )

        XCTAssertTrue(sut.isSelectable)
    }

    func test_isSelectable_whenSelected_returnsTrue() throws {
        let sut = PickableItem(
            identifier: .static("id"),
            isSelected: .static(true)
        )

        XCTAssertTrue(sut.isSelectable)
    }

    func test_selectionOutcome_returnsCustomOutcome() throws {
        let closureExpectation = expectation(description: "")
        closureExpectation.assertForOverFulfill = true
        let sut = PickableItem(
            identifier: .static("id"),
            isSelected: .static(false)
        )

        sut.onPick = { _ in
            closureExpectation.fulfill()
        }

        if case .custom(let customClosure) = sut.selectionOutcome {
            customClosure()
        } else {
            XCTFail("\(sut.selectionOutcome) is not `custom`")
        }

        wait(for: [closureExpectation], timeout: 0.01)
    }

    func test_selectionOutcome_hasWeakReference() throws {
        var sut: PickableItem? = PickableItem(
            identifier: .static("id"),
            isSelected: .static(false)
        )
        weak var leakSut = sut
        let selectionOutcome = sut!.selectionOutcome

        sut = nil

        XCTAssertNil(leakSut, "\(String(describing: sut)) is not released from memory")

        if case .custom(let customClosure) = selectionOutcome {
            customClosure()
        } else {
            XCTFail("\(sut!.selectionOutcome) is not an action")
        }
    }
}
