//
//  QAMenu+TriggerTests.swift
//
//  Created by Hans Seiffert on 31.01.21.
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

import XCTest
import QAMenu

class QAMenuTriggerTests: XCTestCase {

    // MARK: - init

    func test_init_whenGivenEmptyString_returnsNil() throws {
        let sut = QAMenu.Trigger(stringValue: "")
        XCTAssertNil(sut)
    }

    func test_init_whenGivenShakeAsString_returnsShakeTrigger() throws {
        let sut = QAMenu.Trigger(stringValue: "shake")
        XCTAssertEqual(sut, .shake)
    }

    func test_init_whenGivenRandomStringWithCharacters_returnsNil() throws {
        let sut = QAMenu.Trigger(stringValue: "s1.0")
        XCTAssertNil(sut)
    }

    // MARK: - key

    func test_key_whenSelfIsShake_returnsShake() throws {
        let sut = QAMenu.Trigger.shake
        let key = sut.key
        XCTAssertEqual(key, "shake")
    }

    // MARK: - [Trigger] + QAMenuConfigurationItemStorable

    // MARK: - init

    func test_init_whenGivenEmptyString_setsSelfToNotrigger() throws {
        let sut = [QAMenu.Trigger](stringValue: "")
        XCTAssertEqual(sut, [])
    }

    func test_init_whenGivenShakeAsString_setsSelfToShake() throws {
        let sut = [QAMenu.Trigger](stringValue: "shake")
        XCTAssertEqual(sut, [.shake])
    }

    func test_init_whenGivenTwoTriggersAsString_setsSelfToBoth() throws {
        let sut = [QAMenu.Trigger](stringValue: "shake,shake")
        XCTAssertEqual(sut, [.shake, .shake])
    }

    func test_init_whenGivenTriggerWithTypoAsString_setsSelfToNoTrigger() throws {
        let sut = [QAMenu.Trigger](stringValue: "shaker")
        XCTAssertEqual(sut, [])
    }

    func test_init_whenGivenRandomString_setsSelfToNoTrigger() throws {
        let sut = [QAMenu.Trigger](stringValue: "abcdedf")
        XCTAssertEqual(sut, [])
    }

    // MARK: - toString

    func test_toString_whenSelfIsEmpty_returnsExpectedString() throws {
        let sut = [QAMenu.Trigger]()
        let string = sut.toString
        XCTAssertEqual(string, "")
    }

    func test_toString_whenSelfIsShake_returnsExpectedString() throws {
        let sut = [QAMenu.Trigger.shake]
        let string = sut.toString
        XCTAssertEqual(string, "shake")
    }

    func test_toString_whenSelfHasTwoTriggers_returnsExpectedString() throws {
        let sut = [
            QAMenu.Trigger.shake,
            QAMenu.Trigger.shake
        ]
        let string = sut.toString
        XCTAssertEqual(string, "shake,shake")
    }
}
