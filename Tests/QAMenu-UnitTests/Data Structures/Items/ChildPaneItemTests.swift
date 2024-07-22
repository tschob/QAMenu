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
        let cancellable = sut.onInvalidationSubject
            .sink(receiveValue: {
                invalidationExpectation.fulfill()
            })

        sut.invalidate()

        wait(for: [invalidationExpectation], timeout: 0.01)
        cancellable.cancel()
    }

    func test_invalidate_sendsOnInvalidationSubject() {
        let sut = ChildPaneItem(pane: { MockPane() })

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

    // MARK: - init (pane)

    func test_initWithPane_whenPassingOnlyMandatoryParameters() throws {
        let mockPane = MockPane()
        let sut = ChildPaneItem(
            pane: { mockPane }
        )

        ChildPaneItem._assertInitProperties(
            sut,
            pane: mockPane,
            title: mockPane.title()
        )
    }

    func test_initWithPane_whenPassingAllParameters() throws {
        let mockPane = MockPane()
        let sut = ChildPaneItem(
            pane: { mockPane },
            value: .static("value"),
            footerText: .static("footer"),
            fallbackString: "fallback"
        )
        .withLayoutType(.static(.vertical(.autoGrow)))
        .withTitleTextAttributes(.static(TextAttributes(textStyle: .caption1, lineBreak: .wrapByCharacter)))
        .withValueTextAttributes(.static(TextAttributes(textStyle: .footnote, lineBreak: .wrapByWord)))

        ChildPaneItem._assertInitProperties(
            sut,
            pane: mockPane,
            title: mockPane.title(),
            value: "value",
            footerText: "footer",
            fallbackString: "fallback",
            layoutType: .vertical(.autoGrow),
            titleTextAttributes: TextAttributes(textStyle: .caption1, lineBreak: .wrapByCharacter),
            valueTextAttributes: TextAttributes(textStyle: .footnote, lineBreak: .wrapByWord)
        )
    }

    // MARK: - init (paneRepresentable)

    func test_initWithPaneRepresentable_whenPassingOnlyMandatoryParameters() throws {
        let mockPaneRepresentable = MockPaneRepresentable()
        let sut = ChildPaneItem(
            title: .static("title"),
            paneRepresentable: { mockPaneRepresentable }
        )

        ChildPaneItem._assertInitProperties(
            sut,
            paneRepresentable: mockPaneRepresentable,
            title: "title"
        )
    }

    func test_initWithPaneRepresentable_whenPassingAllParameters() throws {
        let mockPaneRepresentable = MockPaneRepresentable()
        let sut = ChildPaneItem(
            title: .static("title"),
            paneRepresentable: { mockPaneRepresentable },
            value: .static("value"),
            footerText: .static("footer"),
            fallbackString: "fallback"
        )
        .withLayoutType(.static(.vertical(.autoGrow)))
        .withTitleTextAttributes(.static(TextAttributes(textStyle: .caption1, lineBreak: .wrapByCharacter)))
        .withValueTextAttributes(.static(TextAttributes(textStyle: .footnote, lineBreak: .wrapByWord)))

        ChildPaneItem._assertInitProperties(
            sut,
            paneRepresentable: mockPaneRepresentable,
            title: "title",
            value: "value",
            footerText: "footer",
            fallbackString: "fallback",
            layoutType: .vertical(.autoGrow),
            titleTextAttributes: TextAttributes(textStyle: .caption1, lineBreak: .wrapByCharacter),
            valueTextAttributes: TextAttributes(textStyle: .footnote, lineBreak: .wrapByWord)
        )
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
            options: .static([]),
            onPickedOption: { _, _ in }
        )
        let mockPane = MockPane(groups: [pickerGroup])
        let sut = ChildPaneItem(pane: { mockPane })
        if case .navigationWithPane(let paneClosure, let beforeNavigation) = sut.selectionOutcome {
            beforeNavigation(paneClosure())
        }

        let observeExpectation = expectation(description: "onNavigateBack is triggered")
        observeExpectation.assertForOverFulfill = true
        let onNavigateBackSubscription = sut.onNavigateBackSubject
            .sink(receiveValue: { _ in
                observeExpectation.fulfill()
            })

        pickerGroup.navigateBack(completion: {})

        wait(for: [observeExpectation], timeout: 0.01)
        onNavigateBackSubscription.cancel()
    }

    func test_onNavigateBackSubject_isSentWhenChildPaneIsTriggered() {
        let pickerGroup = PickerGroup(
            title: .static("PickerGroup"),
            options: .static([]),
            onPickedOption: { _, _ in }
        )
        let mockPane = MockPane(groups: [pickerGroup])
        let sut = ChildPaneItem(pane: { mockPane })
        if case .navigationWithPane(let paneClosure, let beforeNavigation) = sut.selectionOutcome {
            beforeNavigation(paneClosure())
        }

        let observeExpectation = expectation(description: "onNavigateBack is triggered")
        observeExpectation.assertForOverFulfill = true
        let cancellable = sut
            .onNavigateBackSubject
            .sink(receiveValue: { _ in
                observeExpectation.fulfill()
        })

        pickerGroup.navigateBack(completion: {})

        wait(for: [observeExpectation], timeout: 0.01)
        cancellable.cancel()
    }

    func test_onNavigateBack_whenTriggered_invalidatesChildPaneItem() {
        let pickerGroup = PickerGroup(
            title: .static("PickerGroup"),
            options: .static([]),
            onPickedOption: { _, _ in }
        )
        let mockPane = MockPane(groups: [pickerGroup])
        let sut = ChildPaneItem(pane: { mockPane })
        if case .navigationWithPane(let paneClosure, let beforeNavigation) = sut.selectionOutcome {
            beforeNavigation(paneClosure())
        }
        let onNavigateBackSubscription = sut.onNavigateBackSubject
            .sink(receiveValue: { closure in
                closure()
            })

        let invalidationExpectation = expectation(description: "ChildPaneItem is invalidated")
        invalidationExpectation.assertForOverFulfill = true
        let onInvalidationSubscription = sut.onInvalidationSubject
            .sink(receiveValue: {
                invalidationExpectation.fulfill()
            })

        pickerGroup.navigateBack { }

        wait(for: [invalidationExpectation], timeout: 0.01)
        onNavigateBackSubscription.cancel()
        onInvalidationSubscription.cancel()
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
