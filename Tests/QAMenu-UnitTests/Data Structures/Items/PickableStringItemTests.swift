//
//  PickableStringItemTests.swift
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
import QAMenu

class PickableStringItemTests: XCTestCase {

    var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        self.disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        self.disposeBag = nil
    }

    func test_typeId() throws {
        XCTAssertEqual(PickableStringItem.typeId, "PickableStringItem")
    }

    func test_invalidate_doesNotCrash_whenNoObserverIsAdded() {
        let sut = PickableStringItem(
            identifier: .static("id"),
            title: .static("title"),
            isSelected: .static(false)
        )

        sut.invalidate()

        XCTAssert(true, "invalidating without an observation doesn't crash")
    }

    func test_invalidate_firesOnInvalidationEvent() {
        let sut = PickableStringItem(
            identifier: .static("id"),
            title: .static("title"),
            isSelected: .static(false)
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
        let sut = PickableStringItem(
            identifier: .static("id"),
            title: .static("title"),
            isSelected: .static(true)
        )

        PickableStringItem._assertInitProperties(
            sut,
            identifier: "id",
            title: "title",
            isSelected: true
        )
    }

    func test_init_whenPassingAllParameters() throws {
        let sut = PickableStringItem(
            identifier: .static("id"),
            title: .static("title"),
            value: .static("value"),
            footerText: .static("footer"),
            isSelected: .static(false)
        )
        .withTitleTextAttributes(.static(TextAttributes(textStyle: .caption1, lineBreak: .wrapByCharacter)))
        .withValueTextAttributes(.static(TextAttributes(textStyle: .footnote, lineBreak: .wrapByWord)))

        PickableStringItem._assertInitProperties(
            sut,
            identifier: "id",
            title: "title",
            footerText: "footer",
            isSelected: false,
            titleTextAttributes: TextAttributes(textStyle: .caption1, lineBreak: .wrapByCharacter),
            valueTextAttributes: TextAttributes(textStyle: .footnote, lineBreak: .wrapByWord)
        )
    }

    // MARK: - Searchable

    func test_searchableContent_whenHavingTitleAndNilValue_containsTheTitle() throws {
        let sut = PickableStringItem(
            identifier: .static("id"),
            title: .static("title"),
            isSelected: .static(false)
        )

        let searchableContent = sut.searchableContent.compactMap { $0 }
        XCTAssertEqual(searchableContent.count, 1)
        XCTAssertTrue(searchableContent.contains("title"))
    }

    func test_searchableContent_whenHavingTitleAndValue_containsTheTitle() throws {
        let sut = PickableStringItem(
            identifier: .static("id"),
            title: .static("title"),
            value: .static("value"),
            isSelected: .static(false)
        )

        let searchableContent = sut.searchableContent.compactMap { $0 }
        XCTAssertEqual(searchableContent.count, 2)
        XCTAssertTrue(searchableContent.contains("title"))
        XCTAssertTrue(searchableContent.contains("value"))
    }

    func test_searchableContent_whenHavingTitleAndFooter_containsAllTwo() throws {
        let sut = PickableStringItem(
            identifier: .static("id"),
            title: .static("title"),
            footerText: .static("footer"),
            isSelected: .static(false)
        )

        let searchableContent = sut.searchableContent.compactMap { $0 }
        XCTAssertEqual(searchableContent.count, 2)
        XCTAssertTrue(searchableContent.contains("title"))
        XCTAssertTrue(searchableContent.contains("footer"))
    }

    func test_searchableContent_whenHavingTitleAndValueAndFooter_containsAllTwo() throws {
        let sut = PickableStringItem(
            identifier: .static("id"),
            title: .static("title"),
            value: .static("value"),
            footerText: .static("footer"),
            isSelected: .static(false)
        )

        let searchableContent = sut.searchableContent.compactMap { $0 }
        XCTAssertEqual(searchableContent.count, 3)
        XCTAssertTrue(searchableContent.contains("title"))
        XCTAssertTrue(searchableContent.contains("value"))
        XCTAssertTrue(searchableContent.contains("footer"))
    }

    // MARK: - Shareable

    func test_isSharingEnabled_whenHavingOnlyATitle_returnsTrue() throws {
        let sut = PickableStringItem(
            identifier: .static("id"),
            title: .static("title"),
            isSelected: .static(false)
        )

        XCTAssertTrue(sut.isSharingEnabled)
    }

    func test_isSharingEnabled_whenHavingAValue_returnsTrue() throws {
        let sut = PickableStringItem(
            identifier: .static("id"),
            title: .static(""),
            value: .static("value"),
            isSelected: .static(false)
        )

        XCTAssertTrue(sut.isSharingEnabled)
    }

    func test_isSharingEnabled_whenValueIsEmpty_returnsFalse() throws {
        let sut = PickableStringItem(
            identifier: .static("id"),
            title: .static(""),
            isSelected: .static(false)
        )

        XCTAssertFalse(sut.isSharingEnabled)
    }

    func test_shareContent_whenHavingOnlyATitle_returnsTitle() throws {
        let sut = PickableStringItem(
            identifier: .static("id"),
            title: .static("title"),
            isSelected: .static(false)
        )

        XCTAssertEqual(sut.shareContent, "title")
    }

    func test_shareContent_whenHavingAValue_returnsValue() throws {
        let sut = PickableStringItem(
            identifier: .static("id"),
            title: .static("title"),
            value: .static("value"),
            isSelected: .static(false)
        )

        XCTAssertEqual(sut.shareContent, "value")
    }

    func test_shareContent_whenTitleAndValueIsEmpty_returnsEmptyString() throws {
        let sut = PickableStringItem(
            identifier: .static("id"),
            title: .static(""),
            isSelected: .static(false)
        )

        XCTAssertEqual(sut.shareContent, "")
    }
}
