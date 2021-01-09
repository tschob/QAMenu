//
//  DynamicTests.swift
//
//  Created by Hans Seiffert on 08.11.20.
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
@testable import QAMenu

class DynamicTests: XCTestCase {

    var stringProperty = AccessLogged("")
    var intProperty = AccessLogged(9)
    var boolProperty = AccessLogged(false)
    var dictionaryProperty = AccessLogged(["key": "value"])
    var objectProperty = AccessLogged(NSObject())

    override func setUpWithError() throws {
        self.stringProperty = AccessLogged("\(Date())")

        self.stringProperty.reset()
        self.intProperty.reset()
        self.boolProperty.reset()
        self.dictionaryProperty.reset()
        self.objectProperty.reset()
    }

    // MARK: - Static

    func test_initWithStringValue_whenValueIsString() throws {
        let expectedString = self.stringProperty._value
        let sut = Dynamic<String>(expectedString)

        assert_static(expectedValue: expectedString, for: sut)
    }

    func test_staticMakeWithStringValue_whenValueIsString() throws {
        let expectedString = self.stringProperty._value
        let sut: Dynamic<String> = .static(expectedString)

        assert_static(expectedValue: expectedString, for: sut)
    }

    func test_boxed_whenValueIsStaticString_returnsStringClosure() throws {
        let expectedString = self.stringProperty._value
        let sut: Dynamic<String> = .static(expectedString)

        XCTAssertEqual(sut.boxed(), expectedString)
    }

    func test_boxed_whenValueIsStaticString_isOnlyExecutedWhenInitialized() throws {
        let sut: Dynamic<String> = .static(self.stringProperty.value)

        XCTAssertEqual(self.stringProperty.accessCount, 1)
        _ = sut.boxed()
        XCTAssertEqual(self.stringProperty.accessCount, 1)
    }

    func test_unboxed_whenValueIsStaticString_returnsString() throws {
        let expectedString = self.stringProperty._value
        let sut: Dynamic<String> = .static(expectedString)

        XCTAssertEqual(sut.unboxed, expectedString)
    }

    func test_unboxed_whenValueIsStaticString_isOnlyExecutedWhenInitialized() throws {
        let sut: Dynamic<String> = .static(self.stringProperty.value)
        XCTAssertEqual(self.stringProperty.accessCount, 1)
        _ = sut.unboxed
        XCTAssertEqual(self.stringProperty.accessCount, 1)
    }

    func test_callAsFunction_whenValueIsStaticString_returnsString() throws {
        let expectedString = self.stringProperty._value
        let sut: Dynamic<String> = .static(expectedString)

        XCTAssertEqual(sut(), expectedString)
    }

    // MARK: - Closure

    func test_initWithStringClosure_whenValueIsString() throws {
        let expectedString = self.stringProperty._value
        let sut = Dynamic<String>({ expectedString })

        assert_closure(expectedValue: expectedString, for: sut)
    }

    func test_staticMakeWithStringClosure_whenValueIsString() throws {
        let expectedString = self.stringProperty._value
        let sut: Dynamic<String> = .computed({ expectedString })

        assert_closure(expectedValue: expectedString, for: sut)
    }

    func test_boxed_whenValueIsComputedString_returnsStringClosure() throws {
        let expectedString = self.stringProperty._value
        let sut: Dynamic<String> = .computed({ expectedString })

        XCTAssertEqual(sut.boxed(), expectedString)
    }

    func test_boxed_whenValueIsComputedString_isOnlyExecutedWhenDirectlyAccessed() throws {
        let sut: Dynamic<String> = .computed({ self.stringProperty.value })

        XCTAssertEqual(self.stringProperty.accessCount, 0)
        _ = sut.boxed()
        XCTAssertEqual(self.stringProperty.accessCount, 1)
    }

    func test_unboxed_whenValueIsComputedString_returnsString() throws {
        let expectedString = self.stringProperty._value
        let sut: Dynamic<String> = .computed({ expectedString })

        XCTAssertEqual(sut.unboxed, expectedString)
    }

    func test_unboxed_whenValueIsComputedString_isOnlyExecutedWhenDirectlyAccessed() throws {
        let sut: Dynamic<String> = .computed({ [weak self] in
            self!.stringProperty.value
        })

        XCTAssertEqual(self.stringProperty.accessCount, 0)
        _ = sut.unboxed
        XCTAssertEqual(self.stringProperty.accessCount, 1)
    }

    func test_callAsFunction_whenValueIsComputedString_returnsString() throws {
        let expectedString = self.stringProperty._value
        let sut: Dynamic<String> = .computed({ expectedString })

        XCTAssertEqual(sut(), expectedString)
    }

    // MARK: - KeyPath

    func test_initWithStringKeyPath_whenValueIsString() throws {
        let expectedString = self.stringProperty._value
        let sut = Dynamic<String>(\DynamicTests.stringProperty.value, for: self)

        assert_keyPath(expectedValue: expectedString, for: sut)
    }

    func test_staticMakeWithStringKeyPath_whenValueIsString() throws {
        let expectedString = self.stringProperty._value
        let sut: Dynamic<String> = .keyPath(\DynamicTests.stringProperty.value, for: self)

        assert_keyPath(expectedValue: expectedString, for: sut)
    }

    func test_boxed_whenValueIsStringKeyPath_returnsStringClosure() throws {
        let expectedString = self.stringProperty._value
        let sut: Dynamic<String> = .keyPath(\DynamicTests.stringProperty.value, for: self)

        XCTAssertEqual(sut.boxed(), expectedString)
    }

    func test_boxed_whenValueIsStringKeyPath_isOnlyExecutedWhenDirectlyAccessed() throws {
        let sut: Dynamic<String> = .keyPath(\DynamicTests.stringProperty.value, for: self)

        XCTAssertEqual(self.stringProperty.accessCount, 0)
        _ = sut.boxed()
        XCTAssertEqual(self.stringProperty.accessCount, 1)
    }

    func test_unboxed_whenValueIsStringKeyPath_returnsString() throws {
        let expectedString = self.stringProperty._value
        let sut: Dynamic<String> = .keyPath(\DynamicTests.stringProperty.value, for: self)

        XCTAssertEqual(sut.unboxed, expectedString)
    }

    func test_unboxed_whenValueIsStringKeyPath_isOnlyExecutedWhenDirectlyAccessed() throws {
        let sut: Dynamic<String> = .keyPath(\DynamicTests.stringProperty.value, for: self)

        XCTAssertEqual(self.stringProperty.accessCount, 0)
        _ = sut.unboxed
        XCTAssertEqual(self.stringProperty.accessCount, 1)
    }

    func test_callAsFunction_whenValueIsStringKeyPath_returnsString() throws {
        let expectedString = self.stringProperty._value
        let sut: Dynamic<String> = .keyPath(\DynamicTests.stringProperty.value, for: self)

        XCTAssertEqual(sut(), expectedString)
    }

    // MARK: - Int

    func test_unboxed_whenValueIsIntClosure_returnsInt() throws {
        let expectedInt = self.intProperty._value
        let sut: Dynamic<Int> = .computed({ [weak self] in
            self!.intProperty.value
        })

        XCTAssertEqual(sut.unboxed, expectedInt)
    }

    func test_unboxed_whenValueIsIntClosure_isOnlyExecutedWhenDirectlyAccessed() throws {
        let sut: Dynamic<Int> = .computed({ [weak self] in
            self!.intProperty.value
        })

        XCTAssertEqual(self.intProperty.accessCount, 0)
        _ = sut.unboxed
        XCTAssertEqual(self.intProperty.accessCount, 1)
    }

    // MARK: - Bool

    func test_unboxed_whenValueIsBoolClosure_returnsBool() throws {
        let expectedBool = self.boolProperty._value
        let sut: Dynamic<Bool> = .computed({ [weak self] in
            self!.boolProperty.value
        })

        XCTAssertEqual(sut.unboxed, expectedBool)
    }

    func test_unboxed_whenValueIsBoolClosure_isOnlyExecutedWhenDirectlyAccessed() throws {
        let sut: Dynamic<Bool> = .computed({ [weak self] in
            self!.boolProperty.value
        })

        XCTAssertEqual(self.boolProperty.accessCount, 0)
        _ = sut.unboxed
        XCTAssertEqual(self.boolProperty.accessCount, 1)
    }

    // MARK: - Dictionary

    func test_unboxed_whenValueIsDictionaryClosure_returnsDictionary() throws {
        let expectedDictionary = self.dictionaryProperty._value
        let sut: Dynamic<[String: String]> = .computed({ [weak self] in
            self!.dictionaryProperty.value
        })

        XCTAssertEqual(sut.unboxed, expectedDictionary)
    }

    func test_unboxed_whenValueIsDictionaryClosure_isOnlyExecutedWhenDirectlyAccessed() throws {
        let sut: Dynamic<[String: String]> = .computed({ [weak self] in
            self!.dictionaryProperty.value
        })

        XCTAssertEqual(self.dictionaryProperty.accessCount, 0)
        _ = sut.unboxed
        XCTAssertEqual(self.dictionaryProperty.accessCount, 1)
    }

    // MARK: - Reference Type

    func test_unboxed_whenValueIsReferenceTypeClosure_returnsReferenceType() throws {
        let expectedObject = self.objectProperty._value
        let sut: Dynamic<NSObject> = .computed({ [weak self] in
            self!.objectProperty.value
        })

        XCTAssertEqual(sut.unboxed, expectedObject)
        XCTAssert(sut.unboxed === expectedObject)
    }

    func test_unboxed_whenValueIsReferenceTypeClosure_isOnlyExecutedWhenDirectlyAccessed() throws {
        let sut: Dynamic<NSObject> = .computed({ [weak self] in
            self!.objectProperty.value
        })

        XCTAssertEqual(self.objectProperty.accessCount, 0)
        _ = sut.unboxed
        XCTAssertEqual(self.objectProperty.accessCount, 1)
    }

    // MARK: - Helper

    class AccessLogged<T> {
        let _value: T

        var accessCount = 0
        var value: T {
            self.accessCount += 1
            return _value
        }

        init(_ value: T) {
            self._value = value
        }

        func reset() {
            self.accessCount = 0
        }
    }

    private func assert_static<T: Equatable>(expectedValue: T, for dynamic: Dynamic<T>) {
        let typeExpectation = expectation(description: "stored value is of type `\(T.self)`")
        let valueExpectation = expectation(description: "stored value equals `\(expectedValue)`")
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
        wait(for: expectations, timeout: 0.01)
    }

    private func assert_closure<T: Equatable>(expectedValue: T, for dynamic: Dynamic<T>) {
        let typeExpectation = expectation(description: "stored value is of type `closure<\(T.self)>`")
        let valueExpectation = expectation(description: "stored value equals `\(expectedValue)`")
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
        wait(for: expectations, timeout: 0.01)
    }

    private func assert_keyPath<T: Equatable>(expectedValue: T, for dynamic: Dynamic<T>) {
        let typeExpectation = expectation(description: "stored value is of type `KeyPath<DynamicTests, \(T.self)>`")
        let valueExpectation = expectation(description: "stored value equals `\(expectedValue)`")
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
        wait(for: expectations, timeout: 0.01)
    }
}
