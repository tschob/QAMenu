//
//  QAMenu+DismissBehaviorTests.swift
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

class QAMenuDismissBehaviorTests: XCTestCase {

    // MARK: - init

    func test_init_whenGivenMinus1AsString_setsSelfToNeverReset() throws {
        let sut = QAMenu.DismissBehavior(stringValue: "-1")
        XCTAssertEqual(sut, QAMenu.DismissBehavior.neverReset)
    }

    func test_init_whenGiven0AsString_setsSelfToResetImmediately() throws {
        let sut = QAMenu.DismissBehavior(stringValue: "0")
        XCTAssertEqual(sut, QAMenu.DismissBehavior.resetImmediately)
    }

    func test_init_whenGiven1AsString_setsSelfToResetAfter1() throws {
        let sut = QAMenu.DismissBehavior(stringValue: "1")
        XCTAssertEqual(sut, QAMenu.DismissBehavior.resetAfter(1))
    }

    func test_init_whenGiven30AsString_setsSelfToResetAfter30() throws {
        let sut = QAMenu.DismissBehavior(stringValue: "30.0")
        XCTAssertEqual(sut, QAMenu.DismissBehavior.resetAfter(30))
    }

    func test_init_whenGivenMinus2AsString_returnsNil() throws {
        let sut = QAMenu.DismissBehavior(stringValue: "-2")
        XCTAssertNil(sut)
    }

    func test_init_whenGivenEmptyString_returnsNil() throws {
        let sut = QAMenu.DismissBehavior(stringValue: "")
        XCTAssertNil(sut)
    }

    func test_init_whenGivenStringWithCharacters_returnsNil() throws {
        let sut = QAMenu.DismissBehavior(stringValue: "s1.0")
        XCTAssertNil(sut)
    }

    // MARK: - timerInterval

    func test_timerInterval_whenSelfIsNeverReset_returnsMinus1() throws {
        let sut = QAMenu.DismissBehavior.neverReset
        let timerInterval = sut.timerInterval
        XCTAssertEqual(timerInterval, -1)
    }

    func test_timerInterval_whenSelfIsResetImmediately_returns0() throws {
        let sut = QAMenu.DismissBehavior.resetImmediately
        let timerInterval = sut.timerInterval
        XCTAssertEqual(timerInterval, 0)
    }

    func test_timerInterval_whenSelfIsResetAfter1Seconds_returns1() throws {
        let sut = QAMenu.DismissBehavior.resetAfter(1)
        let timerInterval = sut.timerInterval
        XCTAssertEqual(timerInterval, 1)
    }

    func test_timerInterval_whenSelfIsResetAfter30Seconds_returns30() throws {
        let sut = QAMenu.DismissBehavior.resetAfter(30)
        let timerInterval = sut.timerInterval
        XCTAssertEqual(timerInterval, 30)
    }

    // MARK: - toString

    func test_toString_whenSelfIsNeverReset_returnsMinus1AsString() throws {
        let sut = QAMenu.DismissBehavior.neverReset
        let string = sut.toString
        XCTAssertEqual(string, "-1.0")
    }

    func test_timerInterval_whenSelfIsResetImmediately_returns0AsString() throws {
        let sut = QAMenu.DismissBehavior.resetImmediately
        let string = sut.toString
        XCTAssertEqual(string, "0.0")
    }

    func test_timerInterval_whenSelfIsResetAfter1Seconds_returns1AsString() throws {
        let sut = QAMenu.DismissBehavior.resetAfter(1)
        let string = sut.toString
        XCTAssertEqual(string, "1.0")
    }

    func test_timerInterval_whenSelfIsResetAfter30Seconds_returns30AsString() throws {
        let sut = QAMenu.DismissBehavior.resetAfter(30)
        let string = sut.toString
        XCTAssertEqual(string, "30.0")
    }
}
