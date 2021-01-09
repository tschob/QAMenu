//
//  LoggerTests.swift
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
@testable import QAMenuUtils

class LoggerTests: XCTestCase {

    override func setUpWithError() throws {
        MockPrinter.clear()
        Logger.printer = MockPrinter.self
        Logger.dateProvider = MockDateProvider.self
    }

    // MARK: - Log Levels

    func test_logLevelVerboseExists() throws {
        _ = Logger.Level.verbose

        XCTAssert(true, "Log level 'verbose' exists")
    }

    func test_logLevelWarningExists() throws {
        _ = Logger.Level.warning

        XCTAssert(true, "Log level 'warning' exists")
    }

    func test_logLevelErrorExists() throws {
        _ = Logger.Level.error

        XCTAssert(true, "Log level 'error' exists")
    }

    func test_logLevelNoneExists() throws {
        _ = Logger.Level.none

        XCTAssert(true, "Log level 'none' exists")
    }

    func test_logLevelPriorityIsSortedCorrectly() throws {
        XCTAssert(Logger.Level.verbose < Logger.Level.warning)
        XCTAssert(Logger.Level.warning < Logger.Level.error)
        XCTAssert(Logger.Level.error < Logger.Level.none)
    }

    // MARK: - Log verbose

    func test_verbose_logsVerbose_whenLogLevelIsEqual() throws {
        Logger.logLevel = .verbose

        let message = "Logging from line: \(#line)"
        Logger.verbose(message)

        let expectedMessage = self.formattedLogMessage(
            message,
            level: .verbose,
            function: MockPrinter.formatFunctionName()
        )
        XCTAssertEqual(MockPrinter.history[0], expectedMessage)
    }

    func test_verbose_logsNoVerbose_whenLogLevelIsAbove() throws {
        Logger.logLevel = .warning

        let message = "Logging from line: \(#line)"
        Logger.verbose(message)

        XCTAssertTrue(MockPrinter.history.isEmpty)
    }

    // MARK: - Log warning

    func test_warning_logsWarning_whenLogLevelIsEqual() throws {
        Logger.logLevel = .warning

        let message = "Logging from line: \(#line)"
        Logger.warning(message)

        let expectedMessage = self.formattedLogMessage(
            message,
            level: .warning,
            function: MockPrinter.formatFunctionName()
        )
        XCTAssertEqual(MockPrinter.history[0], expectedMessage)
    }

    func test_warning_logsWarning_whenLogLevelIsBelow() throws {
        Logger.logLevel = .verbose

        let message = "Logging from line: \(#line)"
        Logger.warning(message)

        let expectedMessage = self.formattedLogMessage(
            message,
            level: .warning,
            function: MockPrinter.formatFunctionName()
        )
        XCTAssertEqual(MockPrinter.history[0], expectedMessage)
    }

    func test_warning_logsNoWarning_whenLogLevelIsAbove() throws {
        Logger.logLevel = .error

        let message = "Logging from line: \(#line)"
        Logger.warning(message)

        XCTAssertTrue(MockPrinter.history.isEmpty)
    }

    // MARK: - Log error

    func test_error_logsError_whenLogLevelIsEqual() throws {
        Logger.logLevel = .error

        let message = "Logging from line: \(#line)"
        Logger.error(message)

        let expectedMessage = self.formattedLogMessage(
            message,
            level: .error,
            function: MockPrinter.formatFunctionName()
        )
        XCTAssertEqual(MockPrinter.history[0], expectedMessage)
    }

    func test_error_logsError_whenLogLevelIsBelow() throws {
        Logger.logLevel = .verbose

        let message = "Logging from line: \(#line)"
        Logger.error(message)

        let expectedMessage = self.formattedLogMessage(
            message,
            level: .error,
            function: MockPrinter.formatFunctionName()
        )
        XCTAssertEqual(MockPrinter.history[0], expectedMessage)
    }

    func test_error_logsNoError_whenLogLevelIsAbove() throws {
        Logger.logLevel = .none

        let message = "Logging from line: \(#line)"
        Logger.error(message)

        XCTAssertTrue(MockPrinter.history.isEmpty)
    }

    // MARK: - Path Handling

    func test_fileNameIsExtracted_whenFileContainsPath() throws {
        Logger.logLevel = .verbose

        let message = "Logging from line: \(#line)"
        Logger.verbose(message, file: "Path/To/The Class/LoggerTests.swift")

        let expectedMessage = self.formattedLogMessage(
            message,
            level: .verbose,
            function: MockPrinter.formatFunctionName()
        )
        XCTAssertEqual(MockPrinter.history[0], expectedMessage)
    }

    func test_fileNameIsExtracted_whenFileContainsNoPath() throws {
        Logger.logLevel = .verbose

        let message = "Logging from line: \(#line)"
        Logger.verbose(message, file: "LoggerTests.swift")

        let expectedMessage = self.formattedLogMessage(
            message,
            level: .verbose,
            function: MockPrinter.formatFunctionName()
        )
        XCTAssertEqual(MockPrinter.history[0], expectedMessage)
    }

    func test_fileNameIsExtracted_whenFileIsEmpty() throws {
        Logger.logLevel = .verbose

        let message = "Logging from line: \(#line)"
        Logger.verbose(message, file: "")

        let expectedMessage = self.formattedLogMessage(
            message,
            level: .verbose,
            file: "",
            function: MockPrinter.formatFunctionName()
        )
        XCTAssertEqual(MockPrinter.history[0], expectedMessage)
    }

    // MARK: - Helper

    private func formattedLogMessage(
        _ message: String,
        level: Logger.Level,
        file: String = "LoggerTests.swift",
        function: String = #function
    ) -> String? {
        var logLevelString = ""
        switch level {
        case .verbose:
            logLevelString = "Verbose"
        case .warning:
            logLevelString = "Warning"
        case .error:
            logLevelString = "Error"
        case .none:
            return nil
        }
        return "\(MockDateProvider.formatted) [QA Menu] [\(logLevelString)] \(file) > \(function) >> \(message)"
    }

    // MARK: - MockPrinter

    private enum MockPrinter: Printer {

        static var history = [String]()

        static func clear() {
            history.removeAll()
        }

        static func print(_ string: String) {
            self.history.append(string)
        }

        static func formatFunctionName(function: String = #function) -> String {
            return "\(function)"
        }
    }

    // MARK: - MockDateProvider

    private enum MockDateProvider: DateProvider {

        static var date: Date {
            return Date(timeIntervalSince1970: 1168249320)
        }

        static var formatted: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss.SSSS"
            return formatter.string(from: self.date)
        }
    }
}
