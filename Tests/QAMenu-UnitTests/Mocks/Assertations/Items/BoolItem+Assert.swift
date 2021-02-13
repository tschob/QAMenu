//
//  BoolItem+Assert.swift
//
//  Created by Hans Seiffert on 01.02.21.
//
//  ---
//  MIT License
//
//  Copyright © 2021 Hans Seiffert
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

import Foundation
import XCTest
import QAMenu

extension BoolItem {

    internal static func _assertInitProperties(
        _ _sut: BoolItem,
        title: String? = nil,
        value: Bool,
        footerText: String? = nil,
        onValueChangeFailure: String,
        testCase: XCTestCase,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        XCTAssertEqual(_sut.title.unboxed, title, file: file, line: line)
        XCTAssertEqual(_sut.value.unboxed, value, file: file, line: line)
        XCTAssertEqual(_sut.footerText?.unboxed, footerText, file: file, line: line)
        let resultExpectation = testCase.expectation(description: "on value closure is called")
        resultExpectation.assertForOverFulfill = true
        _sut.onValueChange(true, _sut) { result in
            if case .failure(let message) = result, message == onValueChangeFailure {
                resultExpectation.fulfill()
            } else {
                XCTFail("\(result) doesn't match .failure(\"\(onValueChangeFailure)\"")
            }
        }
        testCase.wait(for: [resultExpectation], timeout: 0.01)
    }
}
