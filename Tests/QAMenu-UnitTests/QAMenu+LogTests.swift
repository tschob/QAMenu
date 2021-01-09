//
//  QAMenu+LogTests.swift
//
//  Created by Hans Seiffert on 15.11.20.
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

class QAMenu_LogTests: XCTestCase {

    func test_levelVerbose_returnsVerboseLogLevel() throws {
        XCTAssertEqual(QAMenu.Log.Level.verbose.asLoggerLogLevel, .verbose)
    }

    func test_levelWarning_returnsWarningLogLevel() throws {
        XCTAssertEqual(QAMenu.Log.Level.warning.asLoggerLogLevel, .warning)
    }

    func test_levelError_returnsErrorLogLevel() throws {
        XCTAssertEqual(QAMenu.Log.Level.error.asLoggerLogLevel, .error)
    }

    func test_levelNone_returnsNoneLogLevel() throws {
        XCTAssertEqual(QAMenu.Log.Level.none.asLoggerLogLevel, .none)
    }

    func test_logLevel_returnErrorAsDefault() throws {
        XCTAssertEqual(QAMenu.Log.Level.none.asLoggerLogLevel, .none)
    }

    func test_logLevel_canBeChangedToVerbose() throws {
        QAMenu.Log.logLevel = .verbose

        XCTAssertEqual(QAMenu.Log.logLevel, .verbose)
    }

    func test_logLevel_canBeChangedToWarning() throws {
        QAMenu.Log.logLevel = .warning

        XCTAssertEqual(QAMenu.Log.logLevel, .warning)
    }

    func test_logLevel_canBeChangedToError() throws {
        QAMenu.Log.logLevel = .error

        XCTAssertEqual(QAMenu.Log.logLevel, .error)
    }

    func test_logLevel_canBeChangedToNone() throws {
        QAMenu.Log.logLevel = .none

        XCTAssertEqual(QAMenu.Log.logLevel, .none)
    }
}
