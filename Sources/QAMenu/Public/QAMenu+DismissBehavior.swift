//
//  QAMenu+DismissBehavior.swift
//
//  Created by Hans Seiffert on 31.12.21.
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

// MARK: - QAMenu + DismissBehavior

extension QAMenu {

    public enum DismissBehavior: Equatable {
        case resetImmediately
        case resetAfter(TimeInterval)
        case neverReset
    }
}

// MARK: - DismissBehavior + QAMenuConfigurationItemStorable

extension QAMenu.DismissBehavior: QAMenuConfigurationItemStorable {

    public init?(stringValue: String) {
        guard let timerInterval = TimeInterval(stringValue) else {
            return nil
        }
        switch timerInterval {
        case -1:
            self = .neverReset
        case 0:
            self = .resetImmediately
        case 1...:
            self = .resetAfter(timerInterval)
        default:
            return nil
        }
    }

    public var timerInterval: TimeInterval {
        switch self {
        case .resetImmediately:
            return 0
        case .resetAfter(let timeInterval):
            return timeInterval
        case .neverReset:
            return -1
        }
    }

    public var toString: String {
        return String(self.timerInterval)
    }
}
