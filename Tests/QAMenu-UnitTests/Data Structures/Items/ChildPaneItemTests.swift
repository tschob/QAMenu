//
//  ChildPaneItemTests.swift
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

class ChildPaneItemTests: XCTestCase {

    var disposeBag = DisposeBag()

    override func setUpWithError() throws {
        self.disposeBag = DisposeBag()
    }

    func test_typeId() throws {
        XCTAssertEqual(ChildPaneItem.typeId, "ChildPaneItem")
    }

    func test_invalidate_doesNotCrash_whenNoObserverIsAdded() {
        let sut = ChildPaneItem(pane: { MockPane() })

        sut.invalidate()

        XCTAssert(true, "invalidating without an observation doesn't crash")
    }

    func test_invalidate_firesOnInvalidationEvent() {
        let sut = ChildPaneItem(pane: { MockPane() })

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

    // MARK: - init (pane)

    func test_initWithPane_whenOnlyPassingPane() throws {
        let mockPane = MockPane()
        let sut = ChildPaneItem(pane: { mockPane })

        sut.assert_pane_equals(mockPane)
        XCTAssertNil(sut.value?.unboxed)
        XCTAssertNil(sut.footerText?.unboxed)
        XCTAssertNil(sut.footerText?.unboxed)
        XCTAssertEqual(sut.layoutType.unboxed, .horizontal(.singleLine))
        XCTAssertEqual(sut.valueFallbackString, "")
    }

    func test_initWithPane_whenPassingPaneAndValue() throws {
        let mockPane = MockPane()
        let sut = ChildPaneItem(
            pane: { mockPane },
            value: .static("value")
        )

        sut.assert_pane_equals(mockPane)
        XCTAssertEqual(sut.value?.unboxed, "value")
        XCTAssertNil(sut.footerText?.unboxed)
        XCTAssertEqual(sut.layoutType.unboxed, .horizontal(.singleLine))
        XCTAssertEqual(sut.valueFallbackString, "")
    }

    func test_initWithPane_whenPassingPaneValueAndFooter() throws {
        let mockPane = MockPane()
        let sut = ChildPaneItem(
            pane: { mockPane },
            value: .static("value"),
            footerText: .static("footer")
        )

        sut.assert_pane_equals(mockPane)
        XCTAssertEqual(sut.value?.unboxed, "value")
        XCTAssertEqual(sut.footerText?.unboxed, "footer")
        XCTAssertEqual(sut.layoutType.unboxed, .horizontal(.singleLine))
        XCTAssertEqual(sut.valueFallbackString, "")
    }

    func test_initWithPane_whenPassingPaneValueFooterAndLayoutTye() throws {
        let mockPane = MockPane()
        let sut = ChildPaneItem(
            pane: { mockPane },
            value: .static("value"),
            footerText: .static("footer"),
            layoutType: .static(.vertical(.autoGrow))
        )

        sut.assert_pane_equals(mockPane)
        XCTAssertEqual(sut.value?.unboxed, "value")
        XCTAssertEqual(sut.footerText?.unboxed, "footer")
        XCTAssertEqual(sut.layoutType.unboxed, .vertical(.autoGrow))
        XCTAssertEqual(sut.valueFallbackString, "")
    }

    func test_initWithPane_whenPassingPaneValueFooterLayoutTyeAndFallbackString() throws {
        let mockPane = MockPane()
        let sut = ChildPaneItem(
            pane: { mockPane },
            value: .static("value"),
            footerText: .static("footer"),
            layoutType: .static(.vertical(.singleLine)),
            fallbackString: "fallback"
        )

        sut.assert_pane_equals(mockPane)
        XCTAssertEqual(sut.value?.unboxed, "value")
        XCTAssertEqual(sut.footerText?.unboxed, "footer")
        XCTAssertEqual(sut.layoutType.unboxed, .vertical(.singleLine))
        XCTAssertEqual(sut.valueFallbackString, "fallback")
    }

    // MARK: - init (paneRepresentable)

    func test_initWithPaneRepresentable_whenOnlyPassingPaneRepresentable() throws {
        let mockPaneRepresentable = MockPaneRepresentable()
        let sut = ChildPaneItem(
            title: .static("title"),
            paneRepresentable: { mockPaneRepresentable }
        )

        sut.assert_paneRepresentation_equals(mockPaneRepresentable)
        XCTAssertEqual(sut.title?.unboxed, "title")
        XCTAssertNil(sut.value?.unboxed)
        XCTAssertNil(sut.footerText?.unboxed)
        XCTAssertNil(sut.footerText?.unboxed)
        XCTAssertEqual(sut.layoutType.unboxed, .horizontal(.singleLine))
        XCTAssertEqual(sut.valueFallbackString, "")
    }

    func test_initWithPaneRepresentable_whenPassingPaneRepresentableAndValue() throws {
        let mockPaneRepresentable = MockPaneRepresentable()
        let sut = ChildPaneItem(
            title: .static("title"),
            paneRepresentable: { mockPaneRepresentable },
            value: .static("value")
        )

        sut.assert_paneRepresentation_equals(mockPaneRepresentable)
        XCTAssertEqual(sut.title?.unboxed, "title")
        XCTAssertEqual(sut.value?.unboxed, "value")
        XCTAssertNil(sut.footerText?.unboxed)
        XCTAssertEqual(sut.layoutType.unboxed, .horizontal(.singleLine))
        XCTAssertEqual(sut.valueFallbackString, "")
    }

    func test_initWithPaneRepresentable_whenPassingPaneRepresentableValueAndFooter() throws {
        let mockPaneRepresentable = MockPaneRepresentable()
        let sut = ChildPaneItem(
            title: .static("title"),
            paneRepresentable: { mockPaneRepresentable },
            value: .static("value"),
            footerText: .static("footer")
        )

        sut.assert_paneRepresentation_equals(mockPaneRepresentable)
        XCTAssertEqual(sut.title?.unboxed, "title")
        XCTAssertEqual(sut.value?.unboxed, "value")
        XCTAssertEqual(sut.footerText?.unboxed, "footer")
        XCTAssertEqual(sut.layoutType.unboxed, .horizontal(.singleLine))
        XCTAssertEqual(sut.valueFallbackString, "")
    }

    func test_initWithPaneRepresentable_whenPassingRepresentablePaneValueFooterAndLayoutTye() throws {
        let mockPaneRepresentable = MockPaneRepresentable()
        let sut = ChildPaneItem(
            title: .static("title"),
            paneRepresentable: { mockPaneRepresentable },
            value: .static("value"),
            footerText: .static("footer"),
            layoutType: .static(.vertical(.autoGrow))
        )

        sut.assert_paneRepresentation_equals(mockPaneRepresentable)
        XCTAssertEqual(sut.title?.unboxed, "title")
        XCTAssertEqual(sut.value?.unboxed, "value")
        XCTAssertEqual(sut.footerText?.unboxed, "footer")
        XCTAssertEqual(sut.layoutType.unboxed, .vertical(.autoGrow))
        XCTAssertEqual(sut.valueFallbackString, "")
    }

    func test_initWithPaneRepresentable_whenPassingPaneRepresentableValueFooterLayoutTyeAndFallbackString() throws {
        let mockPaneRepresentable = MockPaneRepresentable()
        let sut = ChildPaneItem(
            title: .static("title"),
            paneRepresentable: { mockPaneRepresentable },
            value: .static("value"),
            footerText: .static("footer"),
            layoutType: .static(.vertical(.singleLine)),
            fallbackString: "fallback"
        )

        sut.assert_paneRepresentation_equals(mockPaneRepresentable)
        XCTAssertEqual(sut.title?.unboxed, "title")
        XCTAssertEqual(sut.value?.unboxed, "value")
        XCTAssertEqual(sut.footerText?.unboxed, "footer")
        XCTAssertEqual(sut.layoutType.unboxed, .vertical(.singleLine))
        XCTAssertEqual(sut.valueFallbackString, "fallback")
    }

    // MARK: - Searchable

    func test_searchableContent_whenHavingOnlyPane_containsTheTitle() throws {
        let sut = ChildPaneItem(
            pane: { MockPane(title: "Pane") }
        )

        let searchableContent = sut.searchableContent.compactMap { $0 }
        XCTAssertEqual(searchableContent.count, 1)
        XCTAssertTrue(searchableContent.contains("Pane"))
    }

    func test_searchableContent_whenHavingPaneAndFooter_containsBoth() throws {
        let sut = ChildPaneItem(
            pane: { MockPane(title: "Pane") },
            footerText: .static("footer")
        )

        let searchableContent = sut.searchableContent.compactMap { $0 }
        XCTAssertEqual(searchableContent.count, 2)
        XCTAssertTrue(searchableContent.contains("Pane"))
        XCTAssertTrue(searchableContent.contains("footer"))
    }

    func test_searchableContent_whenHavingPaneAndNilFooter_containsTheTitle() throws {
        let sut = ChildPaneItem(
            pane: { MockPane(title: "Pane") },
            footerText: .static(nil)
        )

        let searchableContent = sut.searchableContent.compactMap { $0 }
        XCTAssertEqual(searchableContent.count, 1)
        XCTAssertTrue(searchableContent.contains("Pane"))
    }

    // MARK: - onNavigateBack

    func test_onNavigateBack_isTriggeredWhenChildPaneIsTriggered() {
        let pickerGroup = PickerGroup(
            title: .static("PickerGroup"),
            options: [],
            onPickedOption: { _, _ in }
        )
        let mockPane = MockPane(groups: [pickerGroup])
        let sut = ChildPaneItem(pane: { mockPane })
        if case .navigationWithPane(let paneClosure, let beforeNavigation) = sut.selectionOutcome {
            beforeNavigation(paneClosure())
        }

        let observeExpectation = expectation(description: "onNavigateBack is triggered")
        observeExpectation.assertForOverFulfill = true
        sut.onNavigateBack
            .observe({ _ in
                observeExpectation.fulfill()
            })
            .disposeWith(self.disposeBag)

        pickerGroup.onNavigateBack.fire(with: {})

        wait(for: [observeExpectation], timeout: 0.01)
    }

    func test_onNavigateBack_whenTriggered_invalidatesChildPaneItem() {
        let pickerGroup = PickerGroup(
            title: .static("PickerGroup"),
            options: [],
            onPickedOption: { _, _ in }
        )
        let mockPane = MockPane(groups: [pickerGroup])
        let sut = ChildPaneItem(pane: { mockPane })
        if case .navigationWithPane(let paneClosure, let beforeNavigation) = sut.selectionOutcome {
            beforeNavigation(paneClosure())
        }
        sut.onNavigateBack
            .observe({ closure in
                closure()
            })
            .disposeWith(self.disposeBag)

        let invalidationExpectation = expectation(description: "ChildPaneItem is invalidated")
        invalidationExpectation.assertForOverFulfill = true
        sut.onInvalidation
            .observe({
                invalidationExpectation.fulfill()
            })
            .disposeWith(self.disposeBag)

        pickerGroup.onNavigateBack.fire { }

        wait(for: [invalidationExpectation], timeout: 0.01)
    }

    // MARK: - Selectable

    func test_isSelectable_returnsTrue() throws {
        let sut = ChildPaneItem(pane: { MockPane() })

        XCTAssertTrue(sut.isSelectable)
    }

    func test_selectionOutcome_whenChildPaneIsPane_returnsNavigation() throws {
        let mockPane = MockPane()
        let sut = ChildPaneItem(pane: { mockPane })

        if case .navigationWithPane(let paneClosure, _) = sut.selectionOutcome,
           paneClosure() == mockPane {
            XCTAssert(true)
        } else {
            XCTFail("\(sut.selectionOutcome) doesn't equal a navigation to \(mockPane)")
        }
    }

    func test_selectionOutcome_whenChildPaneIsPane_addsNavigationTriggerObserver() throws {
        let pickerGroup = PickerGroup(
            title: .static("PickerGroup"),
            options: [],
            onPickedOption: { _, _ in }
        )
        let mockPane = MockPane(groups: [pickerGroup])
        let sut = ChildPaneItem(pane: { mockPane })

        XCTAssertEqual(pickerGroup.onNavigateBack.observers.count, 0)

        if case .navigationWithPane(let paneClosure, let beforeNavigation) = sut.selectionOutcome {
            beforeNavigation(paneClosure())
        }

        XCTAssertEqual(pickerGroup.onNavigateBack.observers.count, 1)
    }

    func test_selectionOutcome_whenChildPaneIsPaneRepresentable_returnsNavigation() throws {
        let mockPaneRepresentable = MockPaneRepresentable()
        let sut = ChildPaneItem(
            title: .static("title"),
            paneRepresentable: { mockPaneRepresentable }
        )

        if case .navigationWithPaneRepresentable(let paneRepresentableClosure, _) = sut.selectionOutcome,
           paneRepresentableClosure() as! MockPaneRepresentable == mockPaneRepresentable {
            XCTAssert(true)
        } else {
            XCTFail("\(sut.selectionOutcome) doesn't equal a navigation to \(mockPaneRepresentable)")
        }
    }
}
