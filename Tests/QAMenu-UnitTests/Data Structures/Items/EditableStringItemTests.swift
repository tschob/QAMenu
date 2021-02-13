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

    var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        self.disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        self.disposeBag = nil
    }

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
            layoutType: .static(.vertical(.autoGrow)),
            fallbackString: "fallback",
            isEditable: .static(false),
            onValueChange: { _, _, result in
                result(.failure("failure"))
            }
        )

        EditableStringItem._assertInitProperties(
            sut,
            title: "title",
            value: "value",
            footerText: "footer",
            layoutType: .vertical(.autoGrow),
            fallbackString: "fallback",
            isEditable: false,
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
}
