//
//  ButtonItemTests.swift
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

class ButtonItemTests: XCTestCase {

    func test_typeId() throws {
        XCTAssertEqual(ButtonItem.typeId, "ButtonItem")
    }

    func test_invalidate_doesNotCrash_whenNoObserverIsAdded() {
        let sut = ButtonItem(
            title: .static("title"),
            action: { _ in }
        )

        sut.invalidate()

        XCTAssert(true, "invalidating without an observation doesn't crash")
    }

    func test_invalidate_firesOnInvalidationEvent() {
        let sut = ButtonItem(
            title: .static("title"),
            action: { _ in }
        )
        let invalidationExpectation = expectation(description: "onInvalidation fires")
        invalidationExpectation.assertForOverFulfill = true
        let cancellable = sut.onInvalidationSubject
            .sink(receiveValue: {
                invalidationExpectation.fulfill()
            })

        sut.invalidate()

        wait(for: [invalidationExpectation], timeout: 0.01)
        cancellable.cancel()
    }

    func test_invalidate_sendsOnInvalidationSubject() {
        let sut = ButtonItem(
            title: .static("title"),
            action: { _ in }
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

    // MARK: - init

    func test_init_whenPassingOnlyMandatoryParameters() throws {
        let sut = ButtonItem(
            title: .static("title"),
            action: { _ in }
        )

        ButtonItem._assertInitProperties(
            sut,
            title: "title"
        )
    }

    func test_init_whenPassingAllParameters() throws {
        let sut = ButtonItem(
            title: .static("title"),
            action: { _ in },
            footerText: .static("footer")
        )

        ButtonItem._assertInitProperties(
            sut,
            title: "title",
            footerText: "footer"
        )
    }

    // MARK: - Status

    func test_status_equalsInitiallyIdle() {
        let sut = ButtonItem(
            title: .static("title"),
            action: { _ in }
        )

        XCTAssertEqual(sut.status, .idle)
    }

    func test_status_canBeChangedToIdle() {
        let sut = ButtonItem(
            title: .static("title"),
            action: { _ in }
        )

        sut.status = .progress("progress")
        sut.status = .idle

        XCTAssertEqual(sut.status, .idle)
    }

    func test_status_canBeChangedToProgress() {
        let sut = ButtonItem(
            title: .static("title"),
            action: { _ in }
        )

        sut.status = .progress("progress")

        XCTAssertEqual(sut.status, .progress("progress"))
    }

    func test_status_whenChangedToProgress_callsInvalidate() {
        let sut = ButtonItem(
            title: .static("title"),
            action: { _ in }
        )

        let invalidationExpectation = expectation(description: "onInvalidation fires")
        invalidationExpectation.assertForOverFulfill = true
        let cancellable = sut.onInvalidationSubject
            .sink(receiveValue: {
                invalidationExpectation.fulfill()
            })

        sut.status = .progress("progress")

        wait(for: [invalidationExpectation], timeout: 0.01)
        cancellable.cancel()
    }

    func test_status_whenChangedToIdle_callsInvalidate() {
        let sut = ButtonItem(
            title: .static("title"),
            action: { _ in }
        )

        sut.status = .idle

        let invalidationExpectation = expectation(description: "onInvalidation fires")
        invalidationExpectation.assertForOverFulfill = true
        let cancellable = sut.onInvalidationSubject
            .sink(receiveValue: {
                invalidationExpectation.fulfill()
            })

        sut.status = .progress("progress")

        wait(for: [invalidationExpectation], timeout: 0.01)
        cancellable.cancel()
    }

    func test_status_canBeChangedFromWithinAction() {
        let sut = ButtonItem(
            title: .static("title"),
            action: { sut in
                sut.status = .progress("progress")
            }
        )

        sut.action(sut)

        XCTAssertEqual(sut.status, .progress("progress"))
    }

    // MARK: - Searchable

    func test_searchableContent_whenHavingTitle_containsOnlyTitle() throws {
        let sut = ButtonItem(
            title: .static("title"),
            action: { _ in }
        )

        let searchableContent = sut.searchableContent.compactMap { $0 }
        XCTAssertEqual(searchableContent.count, 1)
        XCTAssertTrue(searchableContent.contains("title"))
    }

    func test_searchableContent_whenHavingTitleAndFooter_containsBoth() throws {
        let sut = ButtonItem(
            title: .static("title"),
            action: { _ in },
            footerText: .static("footer")
        )

        let searchableContent = sut.searchableContent.compactMap { $0 }
        XCTAssertEqual(searchableContent.count, 2)
        XCTAssertTrue(searchableContent.contains("title"))
        XCTAssertTrue(searchableContent.contains("footer"))
    }

    func test_searchableContent_whenHavingTitleAndNilFooter_containsOnlyTitle() throws {
        let sut = ButtonItem(
            title: .static("title"),
            action: { _ in },
            footerText: .static(nil)
        )

        let searchableContent = sut.searchableContent.compactMap { $0 }
        XCTAssertEqual(searchableContent.count, 1)
        XCTAssertTrue(searchableContent.contains("title"))
    }

    // MARK: - Selectable

    func test_isSelectable_whenStatusIsIdle_returnsTrue() throws {
        let sut = ButtonItem(
            title: .static("title"),
            action: { _ in }
        )
        sut.status = .idle

        XCTAssertTrue(sut.isSelectable)
    }

    func test_isSelectable_whenStatusIsProgress_returnsFalse() throws {
        let sut = ButtonItem(
            title: .static("title"),
            action: { _ in }
        )
        sut.status = .progress("progress")

        XCTAssertFalse(sut.isSelectable)
    }

    func test_selectionOutcome_returnsCustomClosure() throws {
        let actionExpectation = expectation(description: "")
        actionExpectation.assertForOverFulfill = true
        var sut: ButtonItem?
        sut = ButtonItem(
            title: .static("title"),
            action: { _sut in
                if _sut === sut {
                    actionExpectation.fulfill()
                } else {
                    XCTFail("\(_sut) didn't euqal \(String(describing: sut))")
                }
            }
        )

        if case .custom(let closure) = sut!.selectionOutcome {
            closure()
        } else {
            XCTFail("\(sut!.selectionOutcome) is not an action")
        }

        wait(for: [actionExpectation], timeout: 0.01)
    }

    func test_selectionOutcome_hasWeakReference() throws {
        var sut: ButtonItem?
        sut = ButtonItem(
            title: .static("title"),
            action: { _ in }
        )
        weak var leakSut = sut
        let selectionOutcome = sut!.selectionOutcome

        sut = nil

        XCTAssertNil(leakSut, "\(String(describing: sut)) is not released from memory")

        if case .custom(let closure) = selectionOutcome {
            closure()
        } else {
            XCTFail("\(sut!.selectionOutcome) is not an action")
        }
    }
}
