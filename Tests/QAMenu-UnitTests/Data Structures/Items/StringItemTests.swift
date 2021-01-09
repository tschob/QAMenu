//
//  StringItemTests.swift
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

class StringItemTests: XCTestCase {

    var disposeBag = DisposeBag()

    override func setUpWithError() throws {
        self.disposeBag = DisposeBag()
    }

    func test_typeId() throws {
        XCTAssertEqual(StringItem.typeId, "StringItem")
    }

    func test_invalidate_doesNotCrash_whenNoObserverIsAdded() {
        let sut = StringItem(title: .static("key"), value: .static("value"))

        sut.invalidate()

        XCTAssert(true, "invalidating without an observation doesn't crash")
    }

    func test_invalidate_firesOnInvalidationEvent() {
        let sut = StringItem(title: .static("key"), value: .static("value"))

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

    func test_init_whenPassingTitleAndNilValue() throws {
        let sut = StringItem(
            title: .static("key"),
            value: .static(nil)
        )

        assert_stringItem(
            sut,
            title: "key",
            value: nil,
            footerText: nil,
            layoutType: .horizontal(.singleLine),
            fallbackString: "<nil>"
        )
    }

    func test_init_whenPassingTitleAndValue() throws {
        let sut = StringItem(
            title: .static("key"),
            value: .static("value")
        )

        assert_stringItem(
            sut,
            title: "key",
            value: "value",
            footerText: nil,
            layoutType: .horizontal(.singleLine),
            fallbackString: "<nil>"
        )
    }

    func test_init_whenPassingTitleNilValueAndFooter() throws {
        let sut = StringItem(
            title: .static("key"),
            value: .static(nil),
            footerText: .static("footer")
        )

        assert_stringItem(
            sut,
            title: "key",
            value: nil,
            footerText: "footer",
            layoutType: .horizontal(.singleLine),
            fallbackString: "<nil>"
        )
    }

    func test_init_whenPassingTitleAndValueAndFooter() throws {
        let sut = StringItem(
            title: .static("key"),
            value: .static("value"),
            footerText: .static("footer")
        )

        assert_stringItem(
            sut,
            title: "key",
            value: "value",
            footerText: "footer",
            layoutType: .horizontal(.singleLine),
            fallbackString: "<nil>"
        )
    }

    func test_init_whenPassingTitleAndValueAndVerticalLayoutType() throws {
        let sut = StringItem(
            title: .static("key"),
            value: .static("value"),
            layoutType: .static(.vertical(.autoGrow))
        )

        assert_stringItem(
            sut,
            title: "key",
            value: "value",
            footerText: nil,
            layoutType: .vertical(.autoGrow),
            fallbackString: "<nil>"
        )
    }

    func test_init_whenPassingTitleAndValueAndFallbackString() throws {
        let sut = StringItem(
            title: .static("key"),
            value: .static("value"),
            fallbackString: "fallback"
        )

        assert_stringItem(
            sut,
            title: "key",
            value: "value",
            footerText: nil,
            layoutType: .horizontal(.singleLine),
            fallbackString: "fallback"
        )
    }

    func test_init_whenPassingTitleAndValueAndFooterAndVerticalLayoutType() throws {
        let sut = StringItem(
            title: .static("key"),
            value: .static("value"),
            footerText: .static("footer"),
            layoutType: .static(.horizontal(.autoGrow))
        )

        assert_stringItem(
            sut,
            title: "key",
            value: "value",
            footerText: "footer",
            layoutType: .horizontal(.autoGrow),
            fallbackString: "<nil>"
        )
    }

    func test_init_whenPassingTitleAndValueAndFooterAndVerticalLayoutTypeAndFallbackString() throws {
        let sut = StringItem(
            title: .static("key"),
            value: .static("value"),
            footerText: .static("footer"),
            layoutType: .static(.vertical(.singleLine)),
            fallbackString: "fallback"
        )

        assert_stringItem(
            sut,
            title: "key",
            value: "value",
            footerText: "footer",
            layoutType: .vertical(.singleLine),
            fallbackString: "fallback"
        )
    }

    // MARK: - Searchable

    func test_searchableContent_whenHavingTitleAndNilValue_containsTheTitle() throws {
        let sut = StringItem(title: .static("key"), value: .static(nil))

        let searchableContent = sut.searchableContent.compactMap { $0 }
        XCTAssertEqual(searchableContent.count, 1)
        XCTAssertTrue(searchableContent.contains("key"))
    }

    func test_searchableContent_whenHavingTitleAndValue_containsBoth() throws {
        let sut = StringItem(title: .static("key"), value: .static("value"))

        let searchableContent = sut.searchableContent.compactMap { $0 }
        XCTAssertEqual(searchableContent.count, 2)
        XCTAssertTrue(searchableContent.contains("key"))
        XCTAssertTrue(searchableContent.contains("value"))
    }

    func test_searchableContent_whenHavingTitleAndValueAndFooter_containsAllThree() throws {
        let sut = StringItem(
            title: .static("key"),
            value: .static("value"),
            footerText: .static("footer")
        )

        let searchableContent = sut.searchableContent.compactMap { $0 }
        XCTAssertEqual(searchableContent.count, 3)
        XCTAssertTrue(searchableContent.contains("key"))
        XCTAssertTrue(searchableContent.contains("value"))
        XCTAssertTrue(searchableContent.contains("footer"))
    }

    // MARK: - Shareable

    func test_isSharingEnabled_whenHavingAValue_returnsTrue() throws {
        let sut = StringItem(
            title: .static("key"),
            value: .static("value")
        )

        XCTAssertTrue(sut.isSharingEnabled)
    }

    func test_isSharingEnabled_whenValueIsNil_returnsFalse() throws {
        let sut = StringItem(
            title: .static("key"),
            value: .static(nil)
        )

        XCTAssertFalse(sut.isSharingEnabled)
    }

    func test_isSharingEnabled_whenValueIsEmpty_returnsFalse() throws {
        let sut = StringItem(
            title: .static("key"),
            value: .static("")
        )

        XCTAssertFalse(sut.isSharingEnabled)
    }

    func test_shareContent_whenHavingAValue_returnsValue() throws {
        let sut = StringItem(
            title: .static("key"),
            value: .static("value")
        )

        XCTAssertEqual(sut.shareContent, "value")
    }

    func test_shareContent_whenValueIsNil_returnsNil() throws {
        let sut = StringItem(
            title: .static("key"),
            value: .static(nil)
        )

        XCTAssertNil(sut.shareContent)
    }

    func test_shareContent_whenValueIsEmpty_returnsEmptyString() throws {
        let sut = StringItem(
            title: .static("key"),
            value: .static("")
        )

        XCTAssertEqual(sut.shareContent, "")
    }

    // MARK: - Helper

    private func assert_stringItem(
        _ sut: StringItem,
        title: String,
        value: String?,
        footerText: String?,
        layoutType: StringItem.LayoutType,
        fallbackString: String,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        XCTAssertEqual(sut.title?.unboxed, title, file: file, line: line)
        XCTAssertEqual(sut.value?.unboxed, value, file: file, line: line)
        XCTAssertEqual(sut.footerText?.unboxed, footerText, file: file, line: line)
        XCTAssertEqual(sut.layoutType.unboxed, layoutType, file: file, line: line)
        XCTAssertEqual(sut.valueFallbackString, fallbackString, file: file, line: line)
    }
}
