//
//  ShareInteractionHandlerTests.swift
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

class ShareInteractionHandlerTests: XCTestCase {

    // MARK: - init

    func test_init_storesShareableProperties() throws {
        let shareable = CustomShareable()
        let sut = ShareInteractionHandler(shareable: shareable, view: UIView(), present: { ( _ _: (UIViewController) -> Void) in })

        XCTAssertTrue(sut.shareable === shareable)
    }

    func test_init_addsGestureRecognizer() throws {
        let view = UIView()

        XCTAssertEqual(view.gestureRecognizers?.count ?? 0, 0)

        _ = ShareInteractionHandler(shareable: CustomShareable(), view: view, present: { ( _ _: (UIViewController) -> Void) in })

        XCTAssertEqual(view.gestureRecognizers?.count, 1)
    }

    // MARK: - share

    func test_share_whenSharingDisabledAndHavingShareableContent_doesNotCallPresentShareDialog() throws {
        let shareable = CustomShareable()
        shareable.isSharingEnabled = false
        shareable.shareContent = "content"
        let presentExpectation = expectation(description: "present shouldn't be called")
        presentExpectation.isInverted = true
        let sut = ShareInteractionHandler(shareable: shareable, view: UIView(), present: { _ in
            presentExpectation.fulfill()
        })

        sut.share()

        wait(for: [presentExpectation], timeout: 0.01)
    }

    func test_share_whenSharingEnabledAndHavingShareableContent_doesCallPresentShareDialog() throws {
        let shareable = CustomShareable()
        shareable.isSharingEnabled = true
        shareable.shareContent = "content"
        let presentExpectation = expectation(description: "present should be called")
        presentExpectation.assertForOverFulfill = true
        let sut = ShareInteractionHandler(shareable: shareable, view: UIView(), present: { _ in
            presentExpectation.fulfill()
        })

        sut.share()

        wait(for: [presentExpectation], timeout: 0.01)
    }

    func test_share_whenSharingEnabledAndNotHavingShareableContent_doesCallPresentShareDialog() throws {
        let shareable = CustomShareable()
        shareable.isSharingEnabled = true
        shareable.shareContent = nil
        let presentExpectation = expectation(description: "present shouldn't be called")
        presentExpectation.isInverted = true
        let sut = ShareInteractionHandler(shareable: shareable, view: UIView(), present: { _ in
            presentExpectation.fulfill()
        })

        sut.share()

        wait(for: [presentExpectation], timeout: 0.01)
    }

    func test_share_whenNoShareable_doesNotCallPresentShareDialog() throws {
        let presentExpectation = expectation(description: "present shouldn't be called")
        presentExpectation.isInverted = true
        let sut = ShareInteractionHandler(shareable: nil, view: UIView(), present: { _ in
            presentExpectation.fulfill()
        })

        sut.share()

        wait(for: [presentExpectation], timeout: 0.01)
    }

    func test_share_doesCallPresentOnGivenViewController() throws {
        let viewController = ItemUIRepresentableDelegateSpy()
        let shareable = CustomShareable()
        shareable.isSharingEnabled = true
        shareable.shareContent = "content"
        let sut = ShareInteractionHandler(shareable: shareable, view: UIView(), present: { present in
            present(viewController)
        })
        XCTAssert(viewController._present.isEmpty)

        sut.share()

        XCTAssertEqual(viewController._present.count, 1)
        XCTAssert(viewController._present[0].viewController is UIActivityViewController)
    }
}
