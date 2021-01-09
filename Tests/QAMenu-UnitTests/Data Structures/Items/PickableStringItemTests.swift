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

    var disposeBag = DisposeBag()

    override func setUpWithError() throws {
        self.disposeBag = DisposeBag()
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

    func test_init_whenPassingIdentifierAndTitle() throws {
        let sut = PickableStringItem(
            identifier: .static("id"),
            title: .static("title"),
            isSelected: .static(false)
        )

        assert_pickableStringItem(
            sut,
            identifier: "id",
            title: "title",
            footerText: nil,
            isSelected: false
        )
    }

    func test_init_whenPassingIdentifierAndTitleAndFooter() throws {
        let sut = PickableStringItem(
            identifier: .static("id"),
            title: .static("title"),
            footerText: .static("footer"),
            isSelected: .static(false)
        )

        assert_pickableStringItem(
            sut,
            identifier: "id",
            title: "title",
            footerText: "footer",
            isSelected: false
        )
    }

    func test_init_whenPassingIdentifierAndTitleAndIsSelected() throws {
        let sut = PickableStringItem(
            identifier: .static("id"),
            title: .static("title"),
            isSelected: .static(true)
        )

        assert_pickableStringItem(
            sut,
            identifier: "id",
            title: "title",
            footerText: nil,
            isSelected: true
        )
    }

    func test_init_whenPassingIdentifierAndTitleAndFooterAndIsSelected() throws {
        let sut = PickableStringItem(
            identifier: .static("id"),
            title: .static("title"),
            footerText: .static("footer"),
            isSelected: .static(false)
        )

        assert_pickableStringItem(
            sut,
            identifier: "id",
            title: "title",
            footerText: "footer",
            isSelected: false
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

    // MARK: - Shareable

    func test_isSharingEnabled_whenHavingAValue_returnsTrue() throws {
        let sut = PickableStringItem(
            identifier: .static("id"),
            title: .static("title"),
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

    func test_shareContent_whenHavingAValue_returnsValue() throws {
        let sut = PickableStringItem(
            identifier: .static("id"),
            title: .static("title"),
            isSelected: .static(false)
        )

        XCTAssertEqual(sut.shareContent, "title")
    }

    func test_shareContent_whenValueIsEmpty_returnsEmptyString() throws {
        let sut = PickableStringItem(
            identifier: .static("id"),
            title: .static(""),
            isSelected: .static(false)
        )

        XCTAssertEqual(sut.shareContent, "")
    }

    // MARK: - Helper

    private func assert_pickableStringItem(
        _ sut: PickableStringItem,
        identifier: String,
        title: String,
        footerText: String?,
        isSelected: Bool,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        XCTAssertEqual(sut.identifier.unboxed, identifier, file: file, line: line)
        XCTAssertEqual(sut.title.unboxed, title, file: file, line: line)
        XCTAssertEqual(sut.footerText?.unboxed, footerText, file: file, line: line)
        XCTAssertEqual(sut.isSelected.unboxed, isSelected, file: file, line: line)
    }
}
