//
//  BooleanItemViewTests.swift
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

class BooleanItemViewTests: XCTestCase {

    var sut: BooleanItemView!

    var delegateSpy: ItemUIRepresentableDelegateSpy!

    override func setUpWithError() throws {
        self.sut = BooleanItemView()
        self.delegateSpy = ItemUIRepresentableDelegateSpy()
        self.sut.delegate = self.delegateSpy
    }

    // MARK: - init

    func test_init_addsFooterLabel() throws {
        let labels = self.sut.footerContainer.arrangedSubviews.filter { $0 is UILabel }
        XCTAssertEqual(labels.count, 1)
    }

    // MARK: whenNotBoolItem

    func test_setItem_whenNotBoolItem_doesNotCrash() throws {
        self.sut.setItem(MockItem())

        XCTAssert(true, "adding an unsupported item did not crash")
    }

    // MARK: - updateContainerHeight

    func test_updateContainerHeight_whenItemIsInvalidated_isCalled() {
        let mockItem = BoolItem(title: .static("Key"), value: .static(false)) { (_, _, _) in }
        self.sut.setItem(mockItem)

        XCTAssertEqual(self.delegateSpy._updateContainerHeightCount, 0)

        mockItem.invalidate()

        XCTAssertEqual(self.delegateSpy._updateContainerHeightCount, 1)
    }
}
