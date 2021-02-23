//
//  Dynamic.swift
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

public class Dynamic<T> {

    internal enum Value<T> {
        case `static`(T)
        case closure(() -> T)
        case keyPath(Any, AnyKeyPath)
    }

    internal let value: Value<T>

    // MARK: - Initialization

    public required init(_ value: T) {
        self.value = .static(value)
    }

    public required init(_ closure: @escaping () -> T) {
        self.value = .closure(closure)
    }

    public required init<Model>(_ keyPath: KeyPath<Model, T>, for model: Model) {
        self.value = .keyPath(model, keyPath)
    }

    // MARK: - Syntactic sugar

    public class func `static`(_ value: T) -> Self {
        return self.init(value)
    }

    public class func computed(_ closure: @escaping () -> T) -> Self {
        return self.init(closure)
    }

    public class func keyPath<Model>(_ keyPath: KeyPath<Model, T>, for model: Model) -> Self {
        return self.init(keyPath, for: model)
    }

    // MARK: -

    public func callAsFunction() -> T {
        return self.unboxed
    }

    // MARK: - Properties (Public)

    // swiftlint:disable force_cast

    public var boxed: () -> T {
        switch self.value {
        case .static(let value):
            return { value }
        case .closure(let closure):
            return closure
        case .keyPath(let model, let keyPath):
            return { model[keyPath: keyPath] as! T }
        }
    }

    public var unboxed: T {
        switch self.value {
        case .static(let value):
            return value
        case .closure(let closure):
            return closure()
        case .keyPath(let model, let keyPath):
            return model[keyPath: keyPath] as! T
        }
    }
}
