//
//  PickerGroupTests.swift
//
//  Created by Hans Seiffert on 31.12.20.
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

class PickerGroupTests: XCTestCase {

    private var disposeBag = DisposeBag()

    override func setUpWithError() throws {
        self.disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - Init

    func test_init_whenOnlyProvidingEmptyArray() throws {
        let options: [MockPickableItem] = []
        let sut = PickerGroup(
            options: options,
            onPickedOption: { _, _ in }
        )

        assert_pickerGroup(
            sut,
            contains: options,
            title: nil,
            footerText: nil
        )
    }

    func test_init_whenProvidingItems() throws {
        let options: [MockPickableItem] = [
            MockPickableItem(isSelected: false),
            MockPickableItem(isSelected: true)
        ]
        let sut = PickerGroup(
            title: .static(nil),
            options: options,
            onPickedOption: { _, _ in }
        )

        assert_pickerGroup(
            sut,
            contains: options,
            title: nil,
            footerText: nil
        )
    }

    func test_init_whenProvidingTitleAndItems() throws {
        let options: [MockPickableItem] = [
            MockPickableItem(isSelected: false),
            MockPickableItem(isSelected: true)
        ]
        let sut = PickerGroup(
            title: .static("Title"),
            options: options,
            onPickedOption: { _, _ in }
        )

        assert_pickerGroup(
            sut,
            contains: options,
            title: "Title",
            footerText: nil
        )
    }

    func test_init_whenProvidingItemsAndFooter() throws {
        let options: [MockPickableItem] = [
            MockPickableItem(isSelected: false),
            MockPickableItem(isSelected: true)
        ]
        let sut = PickerGroup(
            options: options,
            footerText: .static("footer"),
            onPickedOption: { _, _ in }
        )

        assert_pickerGroup(
            sut,
            contains: options,
            title: nil,
            footerText: "footer"
        )
    }

    func test_init_whenProvidingTitleAndItemsAndFooter() throws {
        let options: [MockPickableItem] = [
            MockPickableItem(isSelected: false),
            MockPickableItem(isSelected: true)
        ]
        let sut = PickerGroup(
            title: .static("title"),
            options: options,
            footerText: .static("footer"),
            onPickedOption: { _, _ in }
        )

        assert_pickerGroup(
            sut,
            contains: options,
            title: "title",
            footerText: "footer"
        )
    }

    func test_init_storesOnPickedItemClosure() throws {
        let options: [MockPickableItem] = []
        let onPickedOptionExpectation = expectation(description: "onPickedOption should be stored as `onPickedOption`")
        onPickedOptionExpectation.assertForOverFulfill = true
        let sut = PickerGroup(
            title: .static("title"),
            options: options,
            footerText: .static("footer"),
            onPickedOption: { _, _ in
                onPickedOptionExpectation.fulfill()
            }
        )

        assert_pickerGroup(
            sut,
            contains: options,
            title: "title",
            footerText: "footer"
        )
        sut.onPickedOption?(MockPickableItem(isSelected: false), { _ in })

        wait(for: [onPickedOptionExpectation], timeout: 0.01)
    }

    func test_init_whenProvidingItems_observesPickableItem() throws {
        let options: [MockPickableItem] = [
            MockPickableItem(isSelected: false),
            MockPickableItem(isSelected: true)
        ]

        XCTAssertNil(options[0].onPick)
        XCTAssertNil(options[1].onPick)

        _ = PickerGroup(
            title: .static(nil),
            options: options,
            footerText: .static("footer"),
            onPickedOption: { _, _ in }
        )

        XCTAssertNotNil(options[0].onPick)
        XCTAssertNotNil(options[1].onPick)
    }

    // MARK: - Invalidatable

    func test_update_whenGivenEmptyArray_replacesInstanceItems() throws {
        let sut = PickerGroup(
            options: [MockPickableItem()],
            onPickedOption: { _, _ in }
        )

        sut.update(options: [])

        XCTAssertTrue(sut.items.isEmpty)
    }

    func test_update_whenGivenEmptyArray_invalidatesTheGroup() throws {
        let sut = PickerGroup(
            options: [MockPickableItem()],
            onPickedOption: { _, _ in }
        )

        let invalidationExpectation = expectation(description: "onInvalidation was called")
        invalidationExpectation.assertForOverFulfill = true
        sut.onInvalidation
            .observe {
                invalidationExpectation.fulfill()
            }
            .disposeWith(self.disposeBag)

        sut.update(options: [])

        wait(for: [invalidationExpectation], timeout: 0.01)
    }

    func test_update_whenGivenOptions_replacesEmptyInstanceItems() throws {
        let sut = PickerGroup(
            options: [],
            onPickedOption: { _, _ in }
        )

        sut.update(options: [MockPickableItem()])

        XCTAssertEqual(sut.items.count, 1)
    }

    func test_update_whenGivenOptions_replacesInstanceItems() throws {
        let sut = PickerGroup(
            options: [MockPickableItem(), MockPickableItem()],
            onPickedOption: { _, _ in }
        )

        sut.update(options: [MockPickableItem()])

        XCTAssertEqual(sut.items.count, 1)
    }

    func test_update_whenGivenOptions_invalidatesTheGroup() throws {
        let sut = PickerGroup(
            options: [MockPickableItem()],
            onPickedOption: { _, _ in }
        )

        let invalidationExpectation = expectation(description: "onInvalidation was called")
        invalidationExpectation.assertForOverFulfill = true
        sut.onInvalidation
            .observe {
                invalidationExpectation.fulfill()
            }
            .disposeWith(self.disposeBag)

        sut.update(options: [MockPickableItem()])

        wait(for: [invalidationExpectation], timeout: 0.01)
    }

    func test_update_whenGivenOptions_referencesTheGroupAsParent() throws {
        let sut = PickerGroup(
            options: [MockPickableItem()],
            onPickedOption: { _, _ in }
        )

        sut.update(options: [MockPickableItem(), MockPickableItem()])

        let groupReferencedExpectation = expectation(description: "")
        groupReferencedExpectation.expectedFulfillmentCount = 2
        sut.items.forEach { item in
            if item.parentGroup === sut {
                groupReferencedExpectation.fulfill()
            }
        }

        wait(for: [groupReferencedExpectation], timeout: 0.01)
    }

    // MARK: - Searchable

    func test_searchableContent_whenHavingNotTitleAndFooter_containsNothing() throws {
        let sut = PickerGroup(
            options: [],
            onPickedOption: { _, _ in }
        )

        let searchableContent = sut.searchableContent.compactMap { $0 }
        XCTAssert(searchableContent.isEmpty)
    }

    func test_searchableContent_whenHavingTitle_containsThat() throws {
        let sut = PickerGroup(
            title: .static("title"),
            options: [],
            onPickedOption: { _, _ in }
        )

        let searchableContent = sut.searchableContent.compactMap { $0 }
        XCTAssertEqual(searchableContent.count, 1)
        XCTAssertTrue(searchableContent.contains("title"))
    }

    func test_searchableContent_whenHavingFooter_containsThat() throws {
        let sut = PickerGroup(
            options: [],
            footerText: .static("footer"),
            onPickedOption: { _, _ in }
        )

        let searchableContent = sut.searchableContent.compactMap { $0 }
        XCTAssertEqual(searchableContent.count, 1)
        XCTAssertTrue(searchableContent.contains("footer"))
    }

    func test_searchableContent_whenHavingTitleAndFooter_containsThose() throws {
        let sut = PickerGroup(
            title: .static("title"),
            options: [],
            footerText: .static("footer"),
            onPickedOption: { _, _ in }
        )

        let searchableContent = sut.searchableContent.compactMap { $0 }
        XCTAssertEqual(searchableContent.count, 2)
        XCTAssertTrue(searchableContent.contains("title"))
        XCTAssertTrue(searchableContent.contains("footer"))
    }

    // MARK: - Invalidatable

    func test_invalidate_doesNotCrash_whenNoObserverIsAdded() throws {
        let sut = PickerGroup(
            title: .static(nil),
            options: [],
            onPickedOption: { _, _ in }
        )

        sut.invalidate()

        XCTAssert(true, "invalidating without an observation doesn't crash")
    }

    func test_invalidate_firesOnInvalidationEvent() throws {
        let sut = PickerGroup(
            title: .static(nil),
            options: [],
            onPickedOption: { _, _ in }
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

    // MARK: - onPick

    func test_whenOnPickResultIsSuccess_invalidatesGroup() throws {
        let mockItem = MockPickableItem()
        let sut = PickerGroup(
            title: .static(nil),
            options: [mockItem],
            onPickedOption: { _, result in
                result(.success(shouldDismiss: false))
            }
        )

        let invalidationExpectation = expectation(description: "onInvalidation fires")
        invalidationExpectation.assertForOverFulfill = true
        sut.onInvalidation
            .observe {
                invalidationExpectation.fulfill()
            }
            .disposeWith(self.disposeBag)

        mockItem.onPick?(mockItem)

        wait(for: [invalidationExpectation], timeout: 0.01)
    }

    func test_whenOnPickResultIsSuccessWithShouldDismiss_triggersOnNavigationBack() throws {
        let mockItem = MockPickableItem()
        let sut = PickerGroup(
            title: .static(nil),
            options: [mockItem],
            onPickedOption: { _, result in
                result(.success(shouldDismiss: true))
            }
        )
        let navigationExpectation = expectation(description: "onNavigateBack fires")
        navigationExpectation.assertForOverFulfill = true
        sut.onNavigateBack
            .observe { completion in
                navigationExpectation.fulfill()
                completion()
            }
            .disposeWith(self.disposeBag)

        mockItem.onPick?(mockItem)

        wait(for: [navigationExpectation], timeout: 0.01)
    }

    func test_whenOnPickResultIsSuccessWithShouldDismiss_invalidatesGroupOnCompletion() throws {
        let mockItem = MockPickableItem()
        let sut = PickerGroup(
            title: .static(nil),
            options: [mockItem],
            onPickedOption: { _, result in
                result(.success(shouldDismiss: true))
            }
        )
        sut.onNavigateBack
            .observe { completion in
                completion()
            }
            .disposeWith(self.disposeBag)

        let invalidationExpectation = expectation(description: "onInvalidation fires")
        invalidationExpectation.assertForOverFulfill = true
        sut.onInvalidation
            .observe {
                invalidationExpectation.fulfill()
            }
            .disposeWith(self.disposeBag)

        mockItem.onPick?(mockItem)

        wait(for: [invalidationExpectation], timeout: 0.01)
    }

    func test_whenOnPickResultIsSuccessWithShouldDismiss_andNoObserverAdded_doesNotCrash() throws {
        let mockItem = MockPickableItem()
        _ = PickerGroup(
            title: .static(nil),
            options: [mockItem],
            onPickedOption: { _, result in
                result(.success(shouldDismiss: true))
            }
        )

        mockItem.onPick?(mockItem)

        let delay = expectation(description: "execution is delayed")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            delay.fulfill()
        }
        wait(for: [delay], timeout: 0.02)

        XCTAssert(true, "picking an item did not crash when onNavigateBack is nil")
    }

    func test_whenOnPickResultIsSuccessWithoutShouldDismiss_doesNotTriggerOnNavigationBack() throws {
        let mockItem = MockPickableItem()
        let sut = PickerGroup(
            title: .static(nil),
            options: [mockItem],
            onPickedOption: { _, result in
                result(.success(shouldDismiss: false))
            }
        )
        let navigationExpectation = expectation(description: "onNavigateBack fires")
        navigationExpectation.assertForOverFulfill = true
        navigationExpectation.isInverted = true
        sut.onNavigateBack
            .observe { completion in
                navigationExpectation.fulfill()
                completion()
            }
            .disposeWith(self.disposeBag)

        mockItem.onPick?(mockItem)

        wait(for: [navigationExpectation], timeout: 0.01)
    }

    func test_handlePickResult_whenResultIsFailure_triggersOnPresentDialog() throws {
        let mockItem = MockPickableItem()
        let sut = PickerGroup(
            title: .static(nil),
            options: [mockItem],
            onPickedOption: { _, result in
                result(.failure("Failure"))
            }
        )
        let presentDialogExpectation = expectation(description: "onPresentDialog fires")
        presentDialogExpectation.assertForOverFulfill = true
        sut.onPresentDialog
            .observe { dialogContent in
                if dialogContent.message == "Failure" {
                    presentDialogExpectation.fulfill()
                }
            }
            .disposeWith(self.disposeBag)

        mockItem.onPick?(mockItem)

        wait(for: [presentDialogExpectation], timeout: 0.01)
    }

    func test_whenOnPickResultIsFailure_andNoObserverAdded_doesNotCrash() throws {
        let mockItem = MockPickableItem()
        _ = PickerGroup(
            title: .static(nil),
            options: [mockItem],
            onPickedOption: { _, result in
                result(.failure("Failure"))
            }
        )

        mockItem.onPick?(mockItem)

        let delay = expectation(description: "execution is delayed")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            delay.fulfill()
        }
        wait(for: [delay], timeout: 0.02)

        XCTAssert(true, "picking an item did not crash when onPresentDialog is nil")
    }

    // MARK: - Helper

    private func assert_pickerGroup(
        _ sut: PickerGroup,
        contains options: [MockPickableItem],
        title: String?,
        footerText: String?,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        XCTAssertEqual(sut.title?.unboxed, title, file: file, line: line)
        if let footerText = footerText {
            XCTAssertEqual(sut.footerText?.unboxed, footerText, file: file, line: line)
        } else {
            XCTAssertNil(sut.footerText, file: file, line: line)
        }
        XCTAssertEqual(sut.options.count, options.count, file: file, line: line)
        var index = 0
        options.forEach { item in
            XCTAssertEqual(sut.options[index] as! MockPickableItem, item, file: file, line: line)
            index += 1
        }
        XCTAssertNotNil(sut.onPickedOption)
    }
}
