//
//  DialogContent+UIKitTests.swift
//
//  Created by Hans Seiffert on 16.03.22.
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
import QAMenu
@testable import QAMenuUIKit

class DialogContentUIKitTests: XCTestCase {

    func test_asUIAlertController_whenHavinDimissAction() throws {
        let sut = DialogContent(
            title: "Title",
            message: "Message",
            closeButtonTitle: "Dismiss"
        ).asUIAlertController()

        XCTAssertEqual(sut?.actions.count, 1)
        XCTAssertEqual(sut?.actions.first?.title, "Dismiss")
    }

    func test_asUIAlertController_whenHavinPrimaryAndSecondaryAction() throws {
        let sut = DialogContent(
            title: "Title",
            message: "Message",
            primaryAction: .init(title: "Primary"),
            secondaryAction: .init(title: "Secondary", buttonType: .destructive)
        ).asUIAlertController()

        XCTAssertEqual(sut?.actions.count, 2)
        XCTAssertEqual(sut?.actions[0].title, "Primary")
        XCTAssertEqual(sut?.actions[1].title, "Secondary")
    }
}
