//
//  Logger.swift
//
//  Created by Hans Seiffert on 30.05.20.
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

import Foundation

public struct Logger {

    // MARK: - Properties (Public)

    public enum Level: Int, Comparable {
        case verbose = 0
        case warning
        case error
        case none

        public static func < (lhs: Level, rhs: Level) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }
    }

    public static var logLevel: Level = .error

    internal static var printer: Printer.Type = SwiftPrinter.self
    internal static var dateProvider: DateProvider.Type = SwiftDateProvider.self

    // MARK: - Properties (Private)

    private static var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSSS"
        return formatter
    }()

    // MARK: - Log Functions (Internal)

    public static func error(
        _ message: String,
        file: String = #file,
        function: String = #function
    ) {
        guard self.logLevel <= .error else {
            return
        }
        self.log(level: "Error", message: message, filePath: file, function: function)
    }

    public  static func warning(
        _ message: String,
        file: String = #file,
        function: String = #function
    ) {
        guard self.logLevel <= .warning else {
            return
        }
        self.log(level: "Warning", message: message, filePath: file, function: function)
    }

    public  static func verbose(
        _ message: String,
        file: String = #file,
        function: String = #function
    ) {
        guard self.logLevel <= .verbose else {
            return
        }
        self.log(level: "Verbose", message: message, filePath: file, function: function)
    }

    // MARK: - Helper (Private)

    private static func log(
        level: String,
        message: String,
        filePath: String,
        function: String
    ) {
        // swiftlint:disable:next line_length
        printer.print("\(formatter.string(from: dateProvider.date)) [QA Menu] [\(level)] \(self.fileFromPath(filePath)) > \(function) >> \(message)")
    }

    private static func fileFromPath(_ path: String) -> String {
        let components = path.components(separatedBy: "/")
        guard !components.isEmpty, let file = components.last else {
            return ""
        }
        return file
    }
}
