//
//  ItemGroupTests.swift
//
//  Created by Hans Seiffert on 10.11.20.
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

class ItemGroupTests: XCTestCase {

    private var disposeBag = DisposeBag()

    override func setUpWithError() throws {
        self.disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - Init

    func test_init_whenPassingOnlyMandatoryParameters() throws {
        let sut = ItemGroup(items: .static([]))

        ItemGroup._assertInitProperties(
            sut,
            items: []
        )
    }

    func test_init_whenPassingAllParameters() throws {
        let items = [
            MockItem(),
            MockItem()
        ]

        let sut = ItemGroup(
            title: .static("title"),
            items: .static(items),
            footerText: .static("footer")
        )

        ItemGroup._assertInitProperties(
            sut,
            title: "title",
            items: items,
            footerText: "footer"
        )
    }

    func test_init_whenProvidingItems_referencesTheGroupAsParent() throws {
        let sut = ItemGroup(items: .static([
            MockItem(),
            MockItem()
        ]))

        let groupReferencedExpectation = expectation(description: "")
        groupReferencedExpectation.expectedFulfillmentCount = 2
        sut.items.unboxed.forEach { item in
            if item.parentGroup === sut {
                groupReferencedExpectation.fulfill()
            }
        }

        wait(for: [groupReferencedExpectation], timeout: 0.01)
    }

    // MARK: - Searchable

    func test_searchableContent_whenHavingNotTitleAndFooter_containsNothing() throws {
        let sut = ItemGroup(items: .static([
            MockItem()
        ]))

        let searchableContent = sut.searchableContent.compactMap { $0 }
        XCTAssert(searchableContent.isEmpty)
    }

    func test_searchableContent_whenHavingTitle_containsThat() throws {
        let sut = ItemGroup(
            title: .static("title"),
            items: .static([
                MockItem()
            ])
        )

        let searchableContent = sut.searchableContent.compactMap { $0 }
        XCTAssertEqual(searchableContent.count, 1)
        XCTAssertTrue(searchableContent.contains("title"))
    }

    func test_searchableContent_whenHavingFooter_containsThat() throws {
        let sut = ItemGroup(
            items: .static([
                MockItem()
            ]),
            footerText: .static("footer")
        )

        let searchableContent = sut.searchableContent.compactMap { $0 }
        XCTAssertEqual(searchableContent.count, 1)
        XCTAssertTrue(searchableContent.contains("footer"))
    }

    func test_searchableContent_whenHavingTitleAndFooter_containsThose() throws {
        let sut = ItemGroup(
            title: .static("title"),
            items: .static([
                MockItem()
            ]),
            footerText: .static("footer")
        )

        let searchableContent = sut.searchableContent.compactMap { $0 }
        XCTAssertEqual(searchableContent.count, 2)
        XCTAssertTrue(searchableContent.contains("title"))
        XCTAssertTrue(searchableContent.contains("footer"))
    }

    // MARK: - Invalidatable

    func test_invalidate_doesNotCrash_whenNoObserverIsAdded() {
        let sut = ItemGroup(items: .static([]))

        sut.invalidate()

        XCTAssert(true, "invalidating without an observation doesn't crash")
    }

    func test_invalidate_firesOnInvalidationEvent() {
        let sut = ItemGroup(items: .static([]))

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

    // MARK: - Update (static options)

    func test_update_whenGivenEmptyStaticArray_replacesInstanceItems() throws {
        let sut = ItemGroup(items: .static([
            MockItem()
        ]))

        sut.update(items: .static([]))

        XCTAssertTrue(sut.items.unboxed.isEmpty)
    }

    func test_update_whenGivenEmptyStaticArray_invalidatesTheGroup() throws {
        let sut = ItemGroup(items: .static([
            MockItem(),
            MockItem()
        ]))

        let invalidationExpectation = expectation(description: "onInvalidation was called")
        invalidationExpectation.assertForOverFulfill = true
        sut.onInvalidation
            .observe {
                invalidationExpectation.fulfill()
            }
            .disposeWith(self.disposeBag)

        sut.update(items: .static([]))

        wait(for: [invalidationExpectation], timeout: 0.01)
    }

    func test_update_whenGivenStaticItems_replacesEmptyInstanceItems() throws {
        let sut = ItemGroup(items: .static([]))

        sut.update(items: .static([
            MockItem()
        ]))

        XCTAssertEqual(sut.items.unboxed.count, 1)
    }

    func test_update_whenGivenStaticItems_replacesInstanceItems() throws {
        let sut = ItemGroup(items: .static([
            MockItem(),
            MockItem()
        ]))

        sut.update(items: .static([
            MockItem()
        ]))

        XCTAssertEqual(sut.items.unboxed.count, 1)
    }

    func test_update_whenGivenStaticItems_invalidatesTheGroup() throws {
        let sut = ItemGroup(items: .static([
            MockItem(),
            MockItem()
        ]))

        let invalidationExpectation = expectation(description: "onInvalidation was called")
        invalidationExpectation.assertForOverFulfill = true
        sut.onInvalidation
            .observe {
                invalidationExpectation.fulfill()
            }
            .disposeWith(self.disposeBag)

        sut.update(items: .static([
            MockItem()
        ]))

        wait(for: [invalidationExpectation], timeout: 0.01)
    }

    func test_update_whenGivenStaticItems_referencesTheGroupAsParent() throws {
        let sut = ItemGroup(items: .static([
            MockItem()
        ]))

        sut.update(items: .static([
            MockItem(),
            MockItem()
        ]))

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
        let sut = ItemGroup(
            items: .async({ instance in
                instance.complete([
                    MockItem()
                ])
            })
        )
        sut.loadContent()

        sut.update(items: .static([]))

        XCTAssertTrue(sut.items.unboxed.isEmpty)
    }

    func test_update_whenGivenEmptyAsyncArray_invalidatesTheGroup() throws {
        let sut = ItemGroup(
            items: .async({ instance in
                instance.complete([
                    MockItem(),
                    MockItem()
                ])
            })
        )
        sut.loadContent()

        let invalidationExpectation = expectation(description: "onInvalidation was called")
        // 2 invalidations are expected: Replacing the group, loading success
        invalidationExpectation.expectedFulfillmentCount = 2
        sut.onInvalidation
            .observe {
                invalidationExpectation.fulfill()
            }
            .disposeWith(self.disposeBag)

        sut.update(
            items: .async({ instance in
                instance.complete([
                    MockItem(),
                    MockItem(),
                    MockItem()
                ])
            }),
            loadDelayedContent: true
        )

        wait(for: [invalidationExpectation], timeout: 0.01)
    }

    func test_update_whenGivenAsyncItems_replacesEmptyInstanceItems() throws {
        let sut = ItemGroup(
            items: .async({ instance in
                instance.complete([])
            })
        )
        sut.loadContent()

        sut.update(
            items: .async({ instance in
                instance.complete([
                    MockItem()
                ])
            }),
            loadDelayedContent: true
        )

        XCTAssertEqual(sut.items.unboxed.count, 1)
    }

    func test_update_whenGivenAsyncItems_replacesInstanceItems() throws {
        let sut = ItemGroup(
            items: .async({ instance in
                instance.complete([
                    MockItem(),
                    MockItem()
                ])
            })
        )
        sut.loadContent()

        sut.update(
            items: .async({ instance in
                instance.complete([
                    MockItem()
                ])
            }),
            loadDelayedContent: true
        )

        XCTAssertEqual(sut.items.unboxed.count, 1)
    }

    func test_update_whenGivenAsyncItems_invalidatesTheGroup() throws {
        let sut = ItemGroup(
            items: .async({ instance in
                instance.complete([
                    MockItem(),
                    MockItem()
                ])
            })
        )
        sut.loadContent()

        let invalidationExpectation = expectation(description: "onInvalidation was called")
        // 2 invalidations are expected: Replacing the group, loading success
        invalidationExpectation.expectedFulfillmentCount = 2
        sut.onInvalidation
            .observe {
                invalidationExpectation.fulfill()
            }
            .disposeWith(self.disposeBag)

        sut.update(
            items: .async({ instance in
                instance.complete([
                    MockItem()
                ])
            }),
            loadDelayedContent: true
        )

        wait(for: [invalidationExpectation], timeout: 0.01)
    }

    func test_update_whenGivenAsyncItems_referencesTheGroupAsParent() throws {
        let sut = ItemGroup(
            items: .async({ instance in
                instance.complete([
                    MockItem()
                ])
            })
        )
        sut.loadContent()

        sut.update(
            items: .async({ instance in
                instance.complete([
                    MockItem(),
                    MockItem()
                ])
            }),
            loadDelayedContent: true
        )

        let groupReferencedExpectation = expectation(description: "")
        groupReferencedExpectation.expectedFulfillmentCount = 2
        sut.items.unboxed.forEach { item in
            if item.parentGroup === sut {
                groupReferencedExpectation.fulfill()
            }
        }

        wait(for: [groupReferencedExpectation], timeout: 0.01)
    }
}
