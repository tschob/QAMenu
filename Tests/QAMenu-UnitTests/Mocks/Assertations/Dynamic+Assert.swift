//
//  Dynamic+Assert.swift
//
//  Created by Hans Seiffert on 22.02.21.
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
@testable import QAMenu

extension Dynamic where T: Equatable {

    internal static func _assertStatic(
        expectedValue: T,
        for dynamic: Dynamic,
        testCase: XCTestCase
    ) {
        let typeExpectation = testCase.expectation(description: "stored value is of type `\(T.self)`")
        let valueExpectation = testCase.expectation(description: "stored value equals `\(expectedValue)`")
        if case .static(let value) = dynamic.value {
            typeExpectation.fulfill()
            if value == expectedValue {
                valueExpectation.fulfill()
            }
        }

        let expectations = [
            typeExpectation,
            valueExpectation
        ]
        testCase.wait(for: expectations, timeout: 0.01)
    }

    internal static func _assertClosure(
        expectedValue: T,
        for dynamic: Dynamic,
        testCase: XCTestCase
    ) {
        let typeExpectation = testCase.expectation(description: "stored value is of type `closure<\(T.self)>`")
        let valueExpectation = testCase.expectation(description: "stored value equals `\(expectedValue)`")
        if case .closure(let valueClosure) = dynamic.value {
            typeExpectation.fulfill()
            if valueClosure() == expectedValue {
                valueExpectation.fulfill()
            }
        }

        let expectations = [
            typeExpectation,
            valueExpectation
        ]
        testCase.wait(for: expectations, timeout: 0.01)
    }

    internal static func _assertKeyPath(
        expectedValue: T,
        for dynamic: Dynamic,
        testCase: XCTestCase
    ) {
        let typeExpectation = testCase.expectation(description: "stored value is of type `KeyPath<DynamicTests, \(T.self)>`")
        let valueExpectation = testCase.expectation(description: "stored value equals `\(expectedValue)`")
        if case .keyPath(let model, let keyPath) = dynamic.value {
            typeExpectation.fulfill()
            let value = model[keyPath: keyPath] as! T
            if value == expectedValue {
                valueExpectation.fulfill()
            }
        }

        let expectations = [
            typeExpectation,
            valueExpectation
        ]
        testCase.wait(for: expectations, timeout: 0.01)
    }
}
