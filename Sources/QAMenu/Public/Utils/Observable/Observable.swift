//
//  Observable.swift
//
//  Created by Hans Seiffert on 20.02.21.
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

open class Observable<T> {

    // MARK: - Properties (Public)

    public private(set) var value: T

    // MARK: - Properties (Private)

    open private(set) var observers = [UUID: (T) -> Void]()

    private let lock = NSRecursiveLock()

    // MARK: - Initialization

    public init(_ value: T) {
        self.value = value
    }

    // MARK: -

    open func observe(
        skipInitialValue: Bool = false,
        _ observer: @escaping (T) -> Void
    ) -> Disposable {
        self.lock.lock()
        defer {
            self.lock.unlock()
        }
        let uuid = UUID()
        observers[uuid] = observer

        if !skipInitialValue {
            callObservers()
        }
        return Disposable({ [weak self] in
            self?.observers.removeValue(forKey: uuid)
        })
    }

    open func update(with value: T) {
        self.value = value
        self.callObservers()
    }

    private func callObservers() {
        self.observers.values.forEach {
            $0(value)
        }
    }
}
