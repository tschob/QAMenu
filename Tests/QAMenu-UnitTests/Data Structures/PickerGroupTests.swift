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

    func test_init_whenPassingOnlyMandatoryParameters() throws {
        let sut = PickerGroup(
            options: .static([]),
            onPickedOption: { _, result in
                result(.failure("failure"))
            }
        )

        PickerGroup._assertInitProperties(
            sut,
            onPickedOptionFailure: "failure",
            testCase: self
        )
    }

    func test_init_whenPassingAllParameters() throws {
        let options: [MockPickableItem] = [
            MockPickableItem(isSelected: false),
            MockPickableItem(isSelected: true)
        ]
        let sut = PickerGroup(
            title: .static(nil),
            options: .static(options),
            footerText: .static("footer"),
            onPickedOption: { _, result in
                result(.failure("failure"))
            }
        )

        PickerGroup._assertInitProperties(
            sut,
            title: nil,
            options: options,
            footerText: "footer",
            onPickedOptionFailure: "failure",
            testCase: self
        )
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
            options: .static(options),
            footerText: .static("footer"),
            onPickedOption: { _, _ in }
        )

        XCTAssertNotNil(options[0].onPick)
        XCTAssertNotNil(options[1].onPick)
    }

    // MARK: - Invalidate

    func test_invalidate_sendsOnInvalidationSubject() {
        let sut = PickerGroup(
            options: .static([MockPickableItem()]),
            onPickedOption: { _, _ in }
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

    // MARK: - Update (static options)

    func test_update_whenGivenEmptyStaticArray_replacesInstanceItems() throws {
        let sut = PickerGroup(
            options: .static([MockPickableItem()]),
            onPickedOption: { _, _ in }
        )

        sut.update(options: .static([]))

        XCTAssertTrue(sut.items.unboxed.isEmpty)
    }

    func test_update_whenGivenEmptyStaticArray_invalidatesTheGroup() throws {
        let sut = PickerGroup(
            options: .static([MockPickableItem()]),
            onPickedOption: { _, _ in }
        )

        let invalidationExpectation = expectation(description: "onInvalidation was called")
        invalidationExpectation.assertForOverFulfill = true
        sut.onInvalidation
            .observe {
                invalidationExpectation.fulfill()
            }
            .disposeWith(self.disposeBag)

        sut.update(options: .static([]))

        wait(for: [invalidationExpectation], timeout: 0.01)
    }

    func test_update_whenGivenStaticOptions_replacesEmptyInstanceItems() throws {
        let sut = PickerGroup(
            options: .static([]),
            onPickedOption: { _, _ in }
        )

        sut.update(options: .static([MockPickableItem()]))

        XCTAssertEqual(sut.items.unboxed.count, 1)
    }

    func test_update_whenGivenStaticOptions_replacesInstanceItems() throws {
        let sut = PickerGroup(
            options: .static([MockPickableItem(), MockPickableItem()]),
            onPickedOption: { _, _ in }
        )

        sut.update(options: .static([MockPickableItem()]))

        XCTAssertEqual(sut.items.unboxed.count, 1)
    }

    func test_update_whenGivenStaticOptions_invalidatesTheGroup() throws {
        let sut = PickerGroup(
            options: .static([MockPickableItem()]),
            onPickedOption: { _, _ in }
        )

        let invalidationExpectation = expectation(description: "onInvalidation was called")
        invalidationExpectation.assertForOverFulfill = true
        sut.onInvalidation
            .observe {
                invalidationExpectation.fulfill()
            }
            .disposeWith(self.disposeBag)

        sut.update(options: .static([MockPickableItem()]))

        wait(for: [invalidationExpectation], timeout: 0.01)
    }

    func test_update_whenGivenStaticOptions_referencesTheGroupAsParent() throws {
        let sut = PickerGroup(
            options: .static([MockPickableItem()]),
            onPickedOption: { _, _ in }
        )

        sut.update(options: .static([MockPickableItem(), MockPickableItem()]))

        let groupReferencedExpectation = expectation(description: "")
        groupReferencedExpectation.expectedFulfillmentCount = 2
        sut.items.unboxed.forEach { item in
            if item.parentGroup === sut {
                groupReferencedExpectation.fulfill()
            }
        }

        wait(for: [groupReferencedExpectation], timeout: 0.01)
    }

    // MARK: - Invalidatable (async options)

    func test_update_whenGivenEmptyAsyncArray_replacesInstanceItems() throws {
        let sut = PickerGroup(
            options: .async({ instance in
                instance.complete([
                    MockPickableItem()
                ])
            }),
            onPickedOption: { _, _ in }
        )
        sut.loadContent()

        sut.update(options: .async({ instance in
            instance.complete([])
        }))

        // After loading the delayed content
        sut.loadContent()
        XCTAssertTrue(sut.items.unboxed.isEmpty)
    }

    func test_update_whenGivenEmptyAsyncArray_invalidatesTheGroup() throws {
        let sut = PickerGroup(
            options: .async({ instance in
                instance.complete([
                    MockPickableItem()
                ])
            }),
            onPickedOption: { _, _ in }
        )
        sut.loadContent()

        let invalidationExpectation = expectation(description: "onInvalidation was called as expected")
        // 2 invalidations are expected: Replacing the group, loading success
        invalidationExpectation.expectedFulfillmentCount = 2
        sut.onInvalidation
            .observe {
                invalidationExpectation.fulfill()
            }
            .disposeWith(self.disposeBag)

        sut.update(options: .async({ instance in
            instance.complete([
                MockPickableItem(),
                MockPickableItem(),
                MockPickableItem()
            ])
        }))

        sut.loadContent()

        wait(for: [invalidationExpectation], timeout: 0.1)
    }

    func test_update_whenGivenAsyncOptions_replacesEmptyInstanceItems() throws {
        let sut = PickerGroup(
            options: .async({ instance in
                instance.complete([])
            }),
            onPickedOption: { _, _ in }
        )
        sut.loadContent()

        sut.update(options: .async({ instance in
            instance.complete([MockPickableItem()])
        }))
        sut.loadContent()

        XCTAssertEqual(sut.items.unboxed.count, 1)
    }

    func test_update_whenGivenAsyncOptions_replacesInstanceItems() throws {
        let sut = PickerGroup(
            options: .async({ instance in
                instance.complete([
                    MockPickableItem(),
                    MockPickableItem()
                ])
            }),
            onPickedOption: { _, _ in }
        )
        sut.loadContent()

        sut.update(
            options: .async({ instance in
                instance.complete([MockPickableItem()])
            }),
            loadDelayedContent: true
        )

        XCTAssertEqual(sut.items.unboxed.count, 1)
    }

    func test_update_whenGivenAsyncOptions_invalidatesTheGroup() throws {
        let sut = PickerGroup(
            options: .async({ instance in
                instance.complete([
                    MockPickableItem()
                ])
            }),
            onPickedOption: { _, _ in }
        )
        sut.loadContent()

        let invalidationExpectation = expectation(description: "onInvalidation was called")
        invalidationExpectation.assertForOverFulfill = true
        sut.onInvalidation
            .observe {
                invalidationExpectation.fulfill()
            }
            .disposeWith(self.disposeBag)

        sut.update(options: .async({ instance in
            instance.complete([MockPickableItem()])
        }))

        wait(for: [invalidationExpectation], timeout: 0.01)
    }

    func test_update_whenGivenAsyncOptions_andContentIsLoaded_referencesTheGroupAsParent() throws {
        let sut = PickerGroup(
            options: .async({ instance in
                instance.complete([
                    MockPickableItem()
                ])
            }),
            onPickedOption: { _, _ in }
        )
        sut.loadContent()

        sut.update(options: .async({ instance in
            instance.complete([
                MockPickableItem(),
                MockPickableItem()
            ])
        }))
        sut.loadContent()

        let groupReferencedExpectation = expectation(description: "the group is referenced as parent")
        groupReferencedExpectation.expectedFulfillmentCount = 2
        sut.items.unboxed.forEach { item in
            if item.parentGroup === sut {
                groupReferencedExpectation.fulfill()
            }
        }

        wait(for: [groupReferencedExpectation], timeout: 0.01)
    }

    func test_update_whenGivenAsyncOptions_andContentIsNotLoaded_doesNotReferencesTheGroupAsParent() throws {
        let sut = PickerGroup(
            options: .async({ instance in
                instance.complete([
                    MockPickableItem()
                ])
            }),
            onPickedOption: { _, _ in }
        )
        sut.loadContent()

        sut.update(options: .async({ instance in
            instance.complete([
                MockPickableItem(),
                MockPickableItem()
            ])
        }))

        let groupReferencedExpectation = expectation(description: "the group is not referenced as parent")
        groupReferencedExpectation.isInverted = true
        sut.items.unboxed.forEach { item in
            if item.parentGroup === sut {
                groupReferencedExpectation.fulfill()
            }
        }

        wait(for: [groupReferencedExpectation], timeout: 0.01)
    }

    // MARK: - Invalidatable (static + async combinations)

    func test_update_whenInitialOptionsAreStatic_andUpdateIsAsync_replacesInstanceItems() throws {
        let sut = PickerGroup(
            options: .static([
                MockPickableItem(),
                MockPickableItem()
            ]),
            onPickedOption: { _, _ in }
        )
        // Before loading the delayed content
        XCTAssertEqual(sut.items.unboxed.count, 2)

        // After loading the delayed content
        sut.loadContent()
        XCTAssertEqual(sut.items.unboxed.count, 2)

        // After setting the async content
        sut.update(options: .async({ instance in
            instance.complete([
                MockPickableItem()
            ])
        }))

        // Before loading the delayed content
        XCTAssertTrue(sut.items.unboxed.isEmpty)

        // After loading the delayed content
        sut.loadContent()
        XCTAssertEqual(sut.items.unboxed.count, 1)
    }

    func test_update_whenInitialOptionsAreAsync_andUpdateIsStatic_replacesInstanceItems() throws {
        let sut = PickerGroup(
            options: .async({ instance in
                instance.complete([MockPickableItem()])
            }),
            onPickedOption: { _, _ in }
        )
        // Before loading the delayed content
        XCTAssertEqual(sut.items.unboxed.count, 0)

        // After loading the delayed content
        sut.loadContent()
        XCTAssertEqual(sut.items.unboxed.count, 1)

        // After setting the static content
        sut.update(options: .static([
            MockPickableItem(),
            MockPickableItem()
        ]))

        // Before loading the delayed content
        XCTAssertEqual(sut.items.unboxed.count, 2)

        // After loading the delayed content
        sut.loadContent()
        XCTAssertEqual(sut.items.unboxed.count, 2)
    }

    // MARK: - Searchable

    func test_searchableContent_whenHavingNotTitleAndFooter_containsNothing() throws {
        let sut = PickerGroup(
            options: .static([]),
            onPickedOption: { _, _ in }
        )

        let searchableContent = sut.searchableContent.compactMap { $0 }
        XCTAssert(searchableContent.isEmpty)
    }

    func test_searchableContent_whenHavingTitle_containsThat() throws {
        let sut = PickerGroup(
            title: .static("title"),
            options: .static([]),
            onPickedOption: { _, _ in }
        )

        let searchableContent = sut.searchableContent.compactMap { $0 }
        XCTAssertEqual(searchableContent.count, 1)
        XCTAssertTrue(searchableContent.contains("title"))
    }

    func test_searchableContent_whenHavingFooter_containsThat() throws {
        let sut = PickerGroup(
            options: .static([]),
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
            options: .static([]),
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
            options: .static([]),
            onPickedOption: { _, _ in }
        )

        sut.invalidate()

        XCTAssert(true, "invalidating without an observation doesn't crash")
    }

    func test_invalidate_firesOnInvalidationEvent() throws {
        let sut = PickerGroup(
            title: .static(nil),
            options: .static([]),
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
            options: .static([mockItem]),
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
            options: .static([mockItem]),
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

    func test_whenOnPickResultIsSuccessWithShouldDismiss_triggersOnNavigationBackSubject() throws {
        let mockItem = MockPickableItem()
        let sut = PickerGroup(
            title: .static(nil),
            options: .static([mockItem]),
            onPickedOption: { _, result in
                result(.success(shouldDismiss: true))
            }
        )
        let navigationExpectation = expectation(description: "onNavigateBack fires")
        navigationExpectation.assertForOverFulfill = true
        let cancellable = sut.onNavigateBackSubject
            .sink(receiveValue: { completion in
                navigationExpectation.fulfill()
                completion()
            })

        mockItem.onPick?(mockItem)

        wait(for: [navigationExpectation], timeout: 0.01)
        cancellable.cancel()
    }

    func test_whenOnPickResultIsSuccessWithShouldDismiss_invalidatesGroupOnCompletion() throws {
        let mockItem = MockPickableItem()
        let sut = PickerGroup(
            title: .static(nil),
            options: .static([mockItem]),
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
            options: .static([mockItem]),
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
            options: .static([mockItem]),
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
            options: .static([mockItem]),
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
            options: .static([mockItem]),
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
}
