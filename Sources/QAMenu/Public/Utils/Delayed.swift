//
//  Delayed.swift
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
import Combine

public class Delayed<Value, Progress, OnFailureOption> {

    public enum State {
        case initialized
        case loading(progress: Progress)
        case loaded(value: Value)
        case failed(progress: Progress, onFailureOption: OnFailureOption)
    }

    // MARK: - Properties (Public)

    public private(set) var state = Observable<State>(.initialized)

    // MARK: - Properties (Private / Internal)

    private let task: (_ delayed: Delayed<Value, Progress, OnFailureOption>) -> Void

    // MARK: - Initialization

    public required init(
        _ value: Value
    ) {
        self.task = { delayed in
            delayed.complete(value)
        }
        self.load()
    }

    public required init(
        _ task: @escaping (_ instance: Delayed<Value, Progress, OnFailureOption>) -> Void
    ) {
        self.task = task
    }

    // MARK: - Syntactic sugar

    public class func `static`(
        _ value: Value
    ) -> Self {
        return self.init(value)
    }

    public class func async(
        _ task: @escaping (_ delayed: Delayed<Value, Progress, OnFailureOption>) -> Void
    ) -> Self {
        return self.init(task)
    }

    // MARK: - Methods (Public)

    public func load() {
        self.task(self)
    }

    public func updateProgress(_ progress: Progress) {
        self.state.update(with: .loading(progress: progress))
    }

    public func complete(_ value: Value) {
        self.state.update(with: .loaded(value: value))
    }

    public func fail(_ progress: Progress, onFailureOption: OnFailureOption) {
        self.state.update(with: .failed(progress: progress, onFailureOption: onFailureOption))
    }
}
