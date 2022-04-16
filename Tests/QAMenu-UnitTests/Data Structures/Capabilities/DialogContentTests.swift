//
//  DialogContentTests.swift
//
//  Created by Hans Seiffert on 16.04.22.
//
//  ---
//  MIT License
//
//  Copyright © 2022 Hans Seiffert
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
@testable import QAMenu

class DialogContentTests: XCTestCase {

    // MARK: - Action

    func test_title() throws {
        let sut = DialogContent.Action(title: "Title")

        XCTAssertEqual(sut.title, "Title")
    }

    func test_action() throws {
        let actionExpectation = expectation(description: "")
        actionExpectation.assertForOverFulfill = true
        let sut = DialogContent.Action(
            title: "Title",
            action: {
                actionExpectation.fulfill()
            }
        )

        sut.action?()

        wait(for: [actionExpectation], timeout: 0.01)
    }

    func test_action_usesNilAsDefault() throws {
        let sut = DialogContent.Action(title: "Title")

        XCTAssertNil(sut.action)
    }

    func test_buttonType() throws {
        let sut = DialogContent.Action(title: "Title", buttonType: .destructive)

        XCTAssertEqual(sut.buttonType, .destructive)
    }

    func test_buttonType_usesCancelAsDefault() throws {
        let sut = DialogContent.Action(title: "Title")

        XCTAssertEqual(sut.buttonType, .cancel)
    }

    // MARK: - Init with closeButtonTitle

    func test_init_whenPassingNoParameters() throws {
        let sut = DialogContent()

        XCTAssertNil(sut.title)
        XCTAssertNil(sut.message)
        XCTAssertEqual(sut.dismissAction!.title, "Ok")
        XCTAssertEqual(sut.dismissAction!.buttonType, .cancel)
    }

    func test_init_whenOnlyTitle() throws {
        let sut = DialogContent(title: "Title")

        XCTAssertEqual(sut.title, "Title")
        XCTAssertNil(sut.message)
        XCTAssertEqual(sut.dismissAction!.title, "Ok")
        XCTAssertEqual(sut.dismissAction!.buttonType, .cancel)
    }

    func test_init_whenPassingTitleMessageAndCloseButtonTitle() throws {
        let sut = DialogContent(title: "Title", message: "Message", closeButtonTitle: "Close")

        XCTAssertEqual(sut.title, "Title")
        XCTAssertEqual(sut.message, "Message")
        XCTAssertEqual(sut.dismissAction!.title, "Close")
        XCTAssertEqual(sut.dismissAction!.buttonType, .cancel)
    }

    // MARK: - Init with dismissAction

    func test_init_whenPassingOnlyDismissAction() throws {
        let sut = DialogContent(dismissAction: .init(title: "Dismiss"))

        XCTAssertNil(sut.title)
        XCTAssertNil(sut.message)
        XCTAssertEqual(sut.dismissAction!.title, "Dismiss")
        XCTAssertNil(sut.dismissAction!.action)
        XCTAssertEqual(sut.dismissAction!.buttonType, .cancel)
    }

    func test_init_whenPassingTitleMessageAndDismissAction() throws {
        let sut = DialogContent(
            title: "Title",
            message: "Message",
            dismissAction: .init(title: "Dismiss")
        )

        XCTAssertEqual(sut.title, "Title")
        XCTAssertEqual(sut.message, "Message")
        XCTAssertEqual(sut.dismissAction!.title, "Dismiss")
        XCTAssertNil(sut.dismissAction!.action)
        XCTAssertEqual(sut.dismissAction!.buttonType, .cancel)
    }

    // MARK: - Init with primaryAction and secondaryAction

    func test_init_whenPassingOnlyPrimaryAndSecondaryAction() throws {
        let sut = DialogContent(
            primaryAction: .init(title: "Primary"),
            secondaryAction: .init(title: "Secondary", buttonType: .destructive)
        )

        XCTAssertNil(sut.title)
        XCTAssertNil(sut.message)
        XCTAssertEqual(sut.primaryAction!.title, "Primary")
        XCTAssertNil(sut.primaryAction!.action)
        XCTAssertEqual(sut.primaryAction!.buttonType, .cancel)
        XCTAssertEqual(sut.secondaryAction!.title, "Secondary")
        XCTAssertNil(sut.secondaryAction!.action)
        XCTAssertEqual(sut.secondaryAction!.buttonType, .destructive)
    }

    func test_init_whenPassingTitleMessagePrimaryAndSecondaryAction() throws {
        let sut = DialogContent(
            title: "Title",
            message: "Message",
            primaryAction: .init(title: "Primary"),
            secondaryAction: .init(title: "Secondary", buttonType: .destructive)
        )

        XCTAssertEqual(sut.title, "Title")
        XCTAssertEqual(sut.message, "Message")
        XCTAssertEqual(sut.primaryAction!.title, "Primary")
        XCTAssertNil(sut.primaryAction!.action)
        XCTAssertEqual(sut.primaryAction!.buttonType, .cancel)
        XCTAssertEqual(sut.secondaryAction!.title, "Secondary")
        XCTAssertNil(sut.secondaryAction!.action)
        XCTAssertEqual(sut.secondaryAction!.buttonType, .destructive)
    }
}
