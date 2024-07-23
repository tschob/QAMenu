//
//  EditableStringItemTests.swift
//
//  Created by Hans Seiffert on 13.02.21.
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
import QAMenu

class EditableStringItemTests: XCTestCase {

    func test_typeId() throws {
        XCTAssertEqual(EditableStringItem.typeId, "EditableStringItem")
    }

    func test_invalidate_doesNotCrash_whenNoObserverIsAdded() {
        let sut = EditableStringItem(
            title: .static("title"),
            value: .static("value"),
            onValueChange: { _, _, _ in }
        )

        sut.invalidate()

        XCTAssert(true, "invalidating without an observation doesn't crash")
    }

    func test_invalidate_firesOnInvalidationEvent() {
        let sut = EditableStringItem(
            title: .static("title"),
            value: .static("value"),
            onValueChange: { _, _, _ in }
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
        let sut = EditableStringItem(
            title: .static("title"),
            value: .static("value"),
            onValueChange: { _, _, _ in }
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
        let sut = EditableStringItem(
            title: .static("title"),
            value: .static("value"),
            onValueChange: { _, _, result in
                result(.failure("failure"))
            }
        )

        EditableStringItem._assertInitProperties(
            sut,
            title: "title",
            value: "value",
            onValueChangeFailure: "failure",
            testCase: self
        )
    }

    func test_init_whenPassingAllParameters() throws {
        let sut = EditableStringItem(
            title: .static("title"),
            value: .static("value"),
            footerText: .static("footer"),
            fallbackString: "fallback",
            isEditable: .static(false),
            onValueChange: { _, _, result in
                result(.failure("failure"))
            }
        )
        .withLayoutType(.static(.vertical(.autoGrow)))
        .withTitleTextAttributes(.static(TextAttributes(textStyle: .caption1, lineBreak: .wrapByCharacter)))
        .withValueTextAttributes(.static(TextAttributes(textStyle: .footnote, lineBreak: .wrapByWord)))

        EditableStringItem._assertInitProperties(
            sut,
            title: "title",
            value: "value",
            footerText: "footer",
            fallbackString: "fallback",
            isEditable: false,
            layoutType: .vertical(.autoGrow),
            titleTextAttributes: TextAttributes(textStyle: .caption1, lineBreak: .wrapByCharacter),
            valueTextAttributes: TextAttributes(textStyle: .footnote, lineBreak: .wrapByWord),
            onValueChangeFailure: "failure",
            testCase: self
        )
    }

    // MARK: - Searchable

    func test_searchableContent_containsTheTitleAndValue() throws {
        let sut = EditableStringItem(
            title: .static("title"),
            value: .static("value"),
            onValueChange: { _, _, _ in }
        )

        let searchableContent = sut.searchableContent.compactMap { $0 }
        XCTAssertEqual(searchableContent.count, 2)
        XCTAssertTrue(searchableContent.contains("title"))
        XCTAssertTrue(searchableContent.contains("value"))
    }

    func test_searchableContent_whenHavingFooter_alsoContainsTheFooter() throws {
        let sut = EditableStringItem(
            title: .static("title"),
            value: .static("value"),
            footerText: .static("footer"),
            onValueChange: { _, _, _ in }
        )

        let searchableContent = sut.searchableContent.compactMap { $0 }
        XCTAssertEqual(searchableContent.count, 3)
        XCTAssertTrue(searchableContent.contains("footer"))
    }

    // MARK: - Selectable

    func test_isSelectable_whenIsEditable_returnsTrue() throws {
        let sut = EditableStringItem(
            title: .static("title"),
            value: .static("value"),
            footerText: .static("footer"),
            isEditable: .static(true),
            onValueChange: { _, _, _ in }
        )

        XCTAssertTrue(sut.isSelectable)
    }

    func test_isSelectable_whenIsNotEditable_returnsFalse() throws {
        let sut = EditableStringItem(
            title: .static("title"),
            value: .static("value"),
            footerText: .static("footer"),
            isEditable: .static(false),
            onValueChange: { _, _, _ in }
        )

        XCTAssertFalse(sut.isSelectable)
    }

    func test_whenSelected_andIsEditable_callsOnShouldEdit() throws {
        let sut = EditableStringItem(
            title: .static("title"),
            value: .static("value"),
            footerText: .static("footer"),
            isEditable: .static(true),
            onValueChange: { _, _, _ in }
        )

        let onShouldEditExpectation = expectation(description: "onShouldEdit is called")
        onShouldEditExpectation.assertForOverFulfill = true
        sut.onShouldEdit = { _ in
            onShouldEditExpectation.fulfill()
        }

        if case .custom(let closure) = sut.selectionOutcome {
            closure()
        }

        wait(for: [onShouldEditExpectation], timeout: 0.01)
    }

    func test_whenSelected_andIsEditable_firesOnEdit() throws {
        let sut = EditableStringItem(
            title: .static("title"),
            value: .static("value"),
            footerText: .static("footer"),
            isEditable: .static(true),
            onValueChange: { _, _, _ in }
        )

        let onEditExpectation = expectation(description: "onEdit is fired")
        onEditExpectation.assertForOverFulfill = true
        let onEditSubscription = sut.onEditSubject
            .sink(receiveValue: { _ in
                onEditExpectation.fulfill()
            })

        if case .custom(let closure) = sut.selectionOutcome {
            closure()
        }

        wait(for: [onEditExpectation], timeout: 0.01)
        onEditSubscription.cancel()
    }

    func test_whenSelected_andIsEditable_sendsOnEditSubject() throws {
        let sut = EditableStringItem(
            title: .static("title"),
            value: .static("value"),
            footerText: .static("footer"),
            isEditable: .static(true),
            onValueChange: { _, _, _ in }
        )

        let onEditSubjectExpectation = expectation(description: "onEditSubject is send")
        onEditSubjectExpectation.assertForOverFulfill = true
        let cancellable = sut.onEditSubject.sink(receiveValue: {
            onEditSubjectExpectation.fulfill()
        })

        if case .custom(let closure) = sut.selectionOutcome {
            closure()
        }

        wait(for: [onEditSubjectExpectation], timeout: 0.01)
        cancellable.cancel()
    }

    func test_whenSelected_andIsNotEditable_doesNotCallOnShouldEdit() throws {
        let sut = EditableStringItem(
            title: .static("title"),
            value: .static("value"),
            footerText: .static("footer"),
            isEditable: .static(false),
            onValueChange: { _, _, _ in }
        )

        let onShouldEditExpectation = expectation(description: "onShouldEdit is not called")
        onShouldEditExpectation.isInverted = true
        sut.onShouldEdit = { _ in
            onShouldEditExpectation.fulfill()
        }

        if case .custom(let closure) = sut.selectionOutcome {
            closure()
        }

        wait(for: [onShouldEditExpectation], timeout: 0.01)
    }

    func test_whenSelected_andIsNotEditable_doesNotFireOnEdit() throws {
        let sut = EditableStringItem(
            title: .static("title"),
            value: .static("value"),
            footerText: .static("footer"),
            isEditable: .static(false),
            onValueChange: { _, _, _ in }
        )

        let onEditExpectation = expectation(description: "onEdit is not fired")
        onEditExpectation.isInverted = true
        let onEditSubscription = sut.onEditSubject
            .sink(receiveValue: { _ in
                onEditExpectation.fulfill()
            })

        if case .custom(let closure) = sut.selectionOutcome {
            closure()
        }

        wait(for: [onEditExpectation], timeout: 0.01)
        onEditSubscription.cancel()
    }

    func test_whenSelected_andIsNotEditable_doesNotSendOnEditSubject() throws {
        let sut = EditableStringItem(
            title: .static("title"),
            value: .static("value"),
            footerText: .static("footer"),
            isEditable: .static(false),
            onValueChange: { _, _, _ in }
        )

        let onEditSubjectExpectation = expectation(description: "onEditSubject is not send")
        onEditSubjectExpectation.isInverted = true
        let cancellable = sut.onEditSubject.sink(receiveValue: {
            onEditSubjectExpectation.fulfill()
        })

        if case .custom(let closure) = sut.selectionOutcome {
            closure()
        }

        wait(for: [onEditSubjectExpectation], timeout: 0.01)
        cancellable.cancel()
    }
}
