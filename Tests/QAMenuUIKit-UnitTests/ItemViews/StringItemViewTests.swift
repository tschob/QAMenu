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

    override func tearDownWithError() throws {
        self.sut = nil
        self.delegateSpy = nil
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

    // MARK: - setItem + EditableStringItem

    func test_setItem_whenItemIsEditableStringItem_andIsEditable_addsOnShouldEditClosure() throws {
        let mockItem = EditableStringItem(
            title: .static("title"),
            value: .static("value"),
            isEditable: .static(true),
            onValueChange: { _, _, _ in }
        )

        XCTAssertNil(mockItem.onShouldEdit)

        self.sut.setItem(mockItem)

        XCTAssertNotNil(mockItem.onShouldEdit)
    }

    func test_setItem_whenItemIsEditableStringItem_andIsNotEditable_addsOnShouldEditClosure() throws {
        let mockItem = EditableStringItem(
            title: .static("title"),
            value: .static("value"),
            isEditable: .static(false),
            onValueChange: { _, _, _ in }
        )

        XCTAssertNil(mockItem.onShouldEdit)

        self.sut.setItem(mockItem)

        XCTAssertNotNil(mockItem.onShouldEdit)
    }

    // MARK: whenNotStringItem

    func test_setItem_whenNotStringItem_doesNotCrash() throws {
        self.sut.setItem(MockItem())

        XCTAssert(true, "adding an unsupported item did not crash")
    }

    func test_setItem_whenNotStringItem_doesNotAddItemAsShareable() throws {
        self.sut.setItem(MockItem())

        XCTAssertNil(self.sut.shareInteractionHandler?.shareable)
    }

    // MARK: - prepareForReuse

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

        XCTAssert((self.delegateSpy.presentationContext as! ItemUIRepresentableDelegateSpy)._present.isEmpty)

        self.sut.shareInteractionHandler?.share()

        XCTAssertEqual((self.delegateSpy.presentationContext as! ItemUIRepresentableDelegateSpy)._present.count, 1)
        XCTAssert((self.delegateSpy.presentationContext as! ItemUIRepresentableDelegateSpy)._present[0].viewController is UIActivityViewController)
    }

    // MARK: - onShouldEdit

    func test_whenItemShouldBeEdited_andIsEditable_presentsTextEditor() throws {
        let mockItem = EditableStringItem(
            title: .static("title"),
            value: .static("value"),
            isEditable: .static(true),
            onValueChange: { _, _, _ in }
        )
        self.sut.textEditorType = SingleLineTextEditorControllerMock.self
        self.sut.setItem(mockItem)
        let delegateSpy = ItemUIRepresentableDelegateSpy()
        self.sut.delegate = delegateSpy

        XCTAssert(delegateSpy._present.isEmpty)

        mockItem.onShouldEdit?(mockItem)

        XCTAssertEqual(delegateSpy._present.count, 1)
        XCTAssert(delegateSpy._present[0].viewController is AlertControllerMock)
    }

    func test_whenItemShouldBeEdited_andIsNotEditable_doesNotPresentTextEditor() throws {
        let mockItem = EditableStringItem(
            title: .static("title"),
            value: .static("value"),
            isEditable: .static(false),
            onValueChange: { _, _, _ in }
        )
        self.sut.setItem(mockItem)
        let delegateSpy = ItemUIRepresentableDelegateSpy()
        self.sut.delegate = delegateSpy

        XCTAssert(delegateSpy._present.isEmpty)

        mockItem.onShouldEdit?(mockItem)

        XCTAssert(delegateSpy._present.isEmpty)
    }

    func test_whenEditItemSucceeded_doesNotPresentsAlert() throws {
        let mockItem = EditableStringItem(
            title: .static("title"),
            value: .static("value"),
            isEditable: .static(true),
            onValueChange: { _, _, result in
                result(.success)
            }
        )
        self.sut.textEditorType = SingleLineTextEditorControllerMock.self
        self.sut.setItem(mockItem)
        let delegateSpy = ItemUIRepresentableDelegateSpy()
        self.sut.delegate = delegateSpy
        mockItem.onShouldEdit?(mockItem)

        XCTAssertEqual(delegateSpy._present.count, 1)

        let textEditorMock = self.sut.textEditor as! SingleLineTextEditorControllerMock
        textEditorMock.onEndEditing("", textEditorMock)

        XCTAssertEqual(delegateSpy._present.count, 1)
    }

    func test_whenEditItemSucceeded_invalidatesItem() throws {
        let mockItem = EditableStringItem(
            title: .static("title"),
            value: .static("value"),
            isEditable: .static(true),
            onValueChange: { _, _, result in
                result(.success)
            }
        )
        self.sut.textEditorType = SingleLineTextEditorControllerMock.self
        self.sut.setItem(mockItem)
        mockItem.onShouldEdit?(mockItem)
        let textEditorMock = self.sut.textEditor as! SingleLineTextEditorControllerMock

        let invalidationExpectation = expectation(description: "onInvalidation is fired")
        invalidationExpectation.assertForOverFulfill = true
        let cancellable = mockItem.onInvalidationSubject
            .sink(receiveValue: {
                invalidationExpectation.fulfill()
            })

        textEditorMock.onEndEditing("", textEditorMock)

        wait(for: [invalidationExpectation], timeout: 0.01)
        cancellable.cancel()
    }

    func test_whenEditItemFailed_presentsErrorAlert() throws {
        let mockItem = EditableStringItem(
            title: .static("title"),
            value: .static("value"),
            isEditable: .static(true),
            onValueChange: { _, _, result in
                result(.failure("invalid"))
            }
        )
        self.sut.textEditorType = SingleLineTextEditorControllerMock.self
        self.sut.setItem(mockItem)
        let delegateSpy = ItemUIRepresentableDelegateSpy()
        self.sut.delegate = delegateSpy
        mockItem.onShouldEdit?(mockItem)

        XCTAssertEqual(delegateSpy._present.count, 1)

        let textEditorMock = self.sut.textEditor as! SingleLineTextEditorControllerMock
        textEditorMock.onEndEditing("", textEditorMock)

        XCTAssertEqual(delegateSpy._present.count, 2)
        XCTAssert(delegateSpy._present[1].viewController is UIAlertController)
        let alert = delegateSpy._present[1].viewController as! UIAlertController
        XCTAssertEqual(alert.title, "Error")
        XCTAssertEqual(alert.message, "invalid")
    }

    func test_whenEditItemFailed_doesNotInvalidatesItem() throws {
        let mockItem = EditableStringItem(
            title: .static("title"),
            value: .static("value"),
            isEditable: .static(true),
            onValueChange: { _, _, result in
                result(.failure("invalid"))
            }
        )
        self.sut.textEditorType = SingleLineTextEditorControllerMock.self
        self.sut.setItem(mockItem)
        mockItem.onShouldEdit?(mockItem)
        let textEditorMock = self.sut.textEditor as! SingleLineTextEditorControllerMock

        let invalidationExpectation = expectation(description: "onInvalidation is not fired")
        invalidationExpectation.isInverted = true
        let cancellable = mockItem.onInvalidationSubject
            .sink(receiveValue: {
                invalidationExpectation.fulfill()
            })

        textEditorMock.onEndEditing("", textEditorMock)

        wait(for: [invalidationExpectation], timeout: 0.01)
        cancellable.cancel()
    }

    func test_whenCancelingEdit_dismissesTextEditor() throws {
        let mockItem = EditableStringItem(
            title: .static("title"),
            value: .static("value"),
            isEditable: .static(true),
            onValueChange: { _, _, _ in }
        )
        self.sut.textEditorType = SingleLineTextEditorControllerMock.self
        self.sut.setItem(mockItem)
        mockItem.onShouldEdit?(mockItem)
        let textEditorMock = self.sut.textEditor as! SingleLineTextEditorControllerMock

        XCTAssertEqual(textEditorMock._dismissCallCount, 0)

        textEditorMock.onCancelEditing(textEditorMock)

        XCTAssertEqual(textEditorMock._dismissCallCount, 1)
        XCTAssertNil(self.sut.textEditor)
    }

    func test_whenEndingEdit_doesNotInvalidateItem() throws {
        let mockItem = EditableStringItem(
            title: .static("title"),
            value: .static("value"),
            isEditable: .static(true),
            onValueChange: { _, _, _ in }
        )
        self.sut.textEditorType = SingleLineTextEditorControllerMock.self
        self.sut.setItem(mockItem)
        mockItem.onShouldEdit?(mockItem)
        let textEditorMock = self.sut.textEditor as! SingleLineTextEditorControllerMock

        let invalidationExpectation = expectation(description: "onInvalidation is not fired")
        invalidationExpectation.isInverted = true
        let cancellable = mockItem.onInvalidationSubject
            .sink(receiveValue: {
                invalidationExpectation.fulfill()
            })

        textEditorMock.onEndEditing("", textEditorMock)

        wait(for: [invalidationExpectation], timeout: 0.01)
        cancellable.cancel()
    }
}
