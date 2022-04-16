//
//  DialogTriggerTests.swift
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

class DialogTriggerTests: XCTestCase {

    let disposeBag = DisposeBag()

    func test_presentDialog_firesOnPresentDialog() throws {
        let sut = MockItem()
        let dialogContent = DialogContent(title: "Dialog")
        let onPresentDialogExpectation = expectation(description: "onPresentDialog fires")
        onPresentDialogExpectation.assertForOverFulfill = true
        sut.onPresentDialog
            .observe { dialog in
                XCTAssertEqual(dialog.title, "Dialog")
                onPresentDialogExpectation.fulfill()
            }
            .disposeWith(self.disposeBag)

        sut.presentDialog(dialogContent)

        wait(for: [onPresentDialogExpectation], timeout: 0.01)
    }
}