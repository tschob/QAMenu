//
//  DisposeBag.swift
//
//  Created by Hans Seiffert on 21.05.20.
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

open class DisposeBag {

    // MARK: - Properties (Private)

    open private(set) var disposables: [Disposable] = []

    private let lock = NSRecursiveLock()

    // MARK: - Initialization

    public init() {}

    // MARK: - Lifecycle

    deinit {
        self.dispose()
    }

    // MARK: -

    open func add(_ disposable: Disposable) {
        self.lock.lock()
        defer {
            self.lock.unlock()
        }
        self.disposables.append(disposable)
    }

    open func dispose() {
        self.lock.lock()
        defer {
            self.lock.unlock()
        }
        self.disposables.forEach {
            $0.dispose()
        }
        self.disposables.removeAll()
    }
}
