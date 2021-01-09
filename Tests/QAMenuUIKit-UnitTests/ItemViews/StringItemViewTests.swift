//
//  StringItemViewTests.swift
//
//  Created by Hans Seiffert on 24.11.20.
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
@testable import QAMenuUIKit

class StringItemViewTests: XCTestCase {

    var sut: StringItemView!

    var delegateSpy: ItemUIRepresentableDelegateSpy!

    override func setUpWithError() throws {
        self.sut = StringItemView()
        self.delegateSpy = ItemUIRepresentableDelegateSpy()
        self.sut.delegate = self.delegateSpy
    }

    // MARK: - init

    func test_init_createsShareInteractionHandler() throws {
        XCTAssertNotNil(self.sut?.shareInteractionHandler)
    }

    func test_init_addsFooterLabel() throws {
        let labels = self.sut.footerContainer.arrangedSubviews.filter { $0 is UILabel }
        XCTAssertEqual(labels.count, 1)
    }

    // MARK: - setItem

    func test_setItem_addsOnInvalidationObserverToItem() throws {
        let mockItem = StringItem(title: .static("Key"), value: .static("Value"))

        XCTAssertEqual(mockItem.onInvalidation.observers.count, 0)

        self.sut.setItem(mockItem)

        XCTAssertEqual(mockItem.onInvalidation.observers.count, 1)
    }

    func test_setItem_whenReplacingExisting_addsOnInvalidationObserverToItem() throws {
        let mockItem1 = StringItem(title: .static("Key"), value: .static("Value"))
        let mockItem2 = StringItem(title: .static("Key1"), value: .static("Value2"))

        self.sut.setItem(mockItem1)

        XCTAssertEqual(mockItem2.onInvalidation.observers.count, 0)

        self.sut.setItem(mockItem2)

        XCTAssertEqual(mockItem2.onInvalidation.observers.count, 1)
    }

    func test_setItem_whenReplacingExisting_removesOnInvalidationObserverFromPreviousItem() throws {
        let mockItem1 = StringItem(title: .static("Key"), value: .static("Value"))
        let mockItem2 = StringItem(title: .static("Key1"), value: .static("Value2"))

        self.sut.setItem(mockItem1)

        XCTAssertEqual(mockItem1.onInvalidation.observers.count, 1)

        self.sut.setItem(mockItem2)

        XCTAssertEqual(mockItem1.onInvalidation.observers.count, 0)
    }

    func test_setItem_addsItemToShareInteractionHandler() throws {
        let mockItem = StringItem(title: .static("Key"), value: .static("Value"))

        self.sut.setItem(mockItem)

        XCTAssertTrue(self.sut!.shareInteractionHandler?.shareable === mockItem)
    }

    func test_setItem_whenReplacingExisting_replacesShareInteractionHandlerItem() throws {
        let mockItem1 = StringItem(title: .static("Key"), value: .static("Value"))
        let mockItem2 = StringItem(title: .static("Key"), value: .static("Value"))

        self.sut.setItem(mockItem1)
        self.sut.setItem(mockItem2)

        XCTAssertTrue(self.sut.shareInteractionHandler?.shareable === mockItem2)
    }

    // MARK: whenNotStringItem

    func test_setItem_whenNotStringItem_doesNotCrash() throws {
        self.sut.setItem(MockItem())

        XCTAssert(true, "adding an unsupported item did not crash")
    }

    func test_setItem_whenNotStringItem_doesNotAddObserverToItem() throws {
        let mockItem = MockItem()
        self.sut.setItem(mockItem)

        XCTAssertEqual(mockItem.onInvalidation.observers.count, 0)
    }

    func test_setItem_whenNotStringItem_doesNotAddItemAsShareable() throws {
        self.sut.setItem(MockItem())

        XCTAssertNil(self.sut.shareInteractionHandler?.shareable)
    }

    // MARK: - prepareForReuse

    func test_prepareForReuse_removesOnInvalidationObserverFromPreviousItem() throws {
        let mockItem = StringItem(title: .static("Key"), value: .static("Value"))
        self.sut.setItem(mockItem)

        self.sut.prepareForReuse()

        XCTAssertEqual(mockItem.onInvalidation.observers.count, 0)
    }

    // MARK: - updateContainerHeight

    func test_updateContainerHeight_whenItemIsInvalidated_isCalled() {
        let mockItem = StringItem(title: .static("Key"), value: .static("Value"))
        self.sut.setItem(mockItem)

        XCTAssertEqual(self.delegateSpy._updateContainerHeightCount, 0)

        mockItem.invalidate()

        XCTAssertEqual(self.delegateSpy._updateContainerHeightCount, 1)
    }

    // MARK: - shareInteractionHandler

    func test_shareInteractionHandler_makesUseOfPresentationContextFromDelegate() {
        let mockItem = StringItem(title: .static("Key"), value: .static("Value"))
        self.sut.setItem(mockItem)

        XCTAssertEqual((self.delegateSpy.presentationContext as! ItemUIRepresentableDelegateSpy)._presentCount, 0)

        self.sut.shareInteractionHandler?.share()

        XCTAssertEqual((self.delegateSpy.presentationContext as! ItemUIRepresentableDelegateSpy)._presentCount, 1)
    }
}
