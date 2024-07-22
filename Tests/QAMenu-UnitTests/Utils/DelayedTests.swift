//
//  DelayedTests.swift
//
//  Created by Hans Seiffert on 21.02.21.
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
@testable import QAMenu

class DelayedTests: XCTestCase {

    // MARK: - init (Static)

    func test_initWithStaticValueTypes_setsStateToLoaded() throws {
        let value = "string"
        let sut = Delayed<String, Int, Bool>(value)

        sut._assert(
            state: .loaded(value: value)
        )
    }

    func test_makeStaticValueTypes_setsStateToLoaded() throws {
        let value = "string"
        let sut: Delayed<String, Int, Bool> = .static(value)

        sut._assert(
            state: .loaded(value: value)
        )
    }

    func test_initWithStaticReferenceTypes_setsStateToLoaded() throws {
        let value = NSObject()
        let sut = Delayed<NSObject, NSObject, NSObject>(value)

        sut._assert(
            state: .loaded(value: value)
        )
    }

    func test_makeStaticReferenceTypes_setsStateToLoaded() throws {
        let value = NSObject()
        let sut: Delayed<NSObject, NSObject, NSObject> = .static(value)

        sut._assert(
            state: .loaded(value: value)
        )
    }

    // MARK: - init (Async)

    func test_initWithAsyncValueTypes_setsStateToInitialized() throws {
        let value = "string"
        let sut = Delayed<String, Int, Bool>({ instance in
            instance.complete(value)
        })

        sut._assert(
            state: .initialized
        )
    }

    func test_makeAsyncValueTypes_setsStateToInitialized() throws {
        let value = "string"
        let sut: Delayed<String, Int, Bool> = .async({ instance in
            instance.complete(value)
        })

        sut._assert(
            state: .initialized
        )
    }

    func test_initWithAsyncReferenceTypes_setsStateToInitialized() throws {
        let value = NSObject()
        let sut = Delayed<NSObject, NSObject, NSObject>({ instance in
            instance.complete(value)
        })

        sut._assert(
            state: .initialized
        )
    }

    func test_makeAsyncReferenceTypes_setsStateToInitialized() throws {
        let value = NSObject()
        let sut: Delayed<NSObject, NSObject, NSObject> = .async({ instance in
            instance.complete(value)
        })

        sut._assert(
            state: .initialized
        )
    }

    // MARK: - load (Static)

    func test_load_whenStaticValueTypes_setsStateToLoaded() throws {
        let value = "string"
        let sut: Delayed<String, Int, Bool> = .static(value)

        sut.load()

        sut._assert(
            state: .loaded(value: value)
        )
    }

    func test_load_whenStaticReferenceTypes_setsStateToLoaded() throws {
        let value = NSObject()
        let sut: Delayed<NSObject, NSObject, NSObject> = .static(value)

        sut.load()

        sut._assert(
            state: .loaded(value: value)
        )
    }

    // MARK: - load (Async)

    func test_load_whenAsyncValueTypes_setsStateToLoading() throws {
        let sut: Delayed<String, Int, Bool> = .async({ instance in
            instance.updateProgress(1)
        })
        sut.load()

        sut._assert(
            state: .loading(progress: 1)
        )
    }

    func test_load_whenAsyncValueTypes_setsStateToLoadedOnceCompleted() throws {
        let sut: Delayed<String, Int, Bool> = .async({ instance in
            instance.updateProgress(1)
            instance.complete("complete")
        })
        sut.load()

        sut._assert(
            state: .loaded(value: "complete")
        )
    }

    func test_load_whenAsyncValueTypes_setsStateToFailedOnFailure() throws {
        let sut: Delayed<String, Int, Bool> = .async({ instance in
            instance.updateProgress(1)
            instance.fail(2, onFailureOption: true)
        })
        sut.load()

        sut._assert(
            state: .failed(progress: 2, onFailureOption: true)
        )
    }

    func test_load_whenAsyncReferenceTypes_setsStateToLoading() throws {
        let progress = NSObject()
        let sut: Delayed<NSObject, NSObject, NSObject> = .async({ instance in
            instance.updateProgress(progress)
        })
        sut.load()

        sut._assert(
            state: .loading(progress: progress)
        )
    }

    func test_load_whenAsyncReferenceTypes_setsStateToLoadedOnceCompleted() throws {
        let value = NSObject()
        let sut: Delayed<NSObject, NSObject, NSObject> = .async({ instance in
            instance.updateProgress(NSObject())
            instance.complete(value)
        })
        sut.load()

        sut._assert(
            state: .loaded(value: value)
        )
    }

    func test_load_whenAsyncReferenceTypes_setsStateToFailedOnFailure() throws {
        let progress = NSObject()
        let onFailureOption = NSObject()
        let sut: Delayed<NSObject, NSObject, NSObject> = .async({ instance in
            instance.updateProgress(NSObject())
            instance.fail(progress, onFailureOption: onFailureOption)
        })
        sut.load()

        sut._assert(
            state: .failed(progress: progress, onFailureOption: onFailureOption)
        )
    }

    // MARK: - updateProgress

    func test_updateProgress_callsObservableStateWithLoadingState() throws {
        let sut: Delayed<String, String, String> = .async({ instance in
            instance.updateProgress("progress1")
            instance.updateProgress("progress2")
        })

        let observableExpectation = self.expectation(description: "")
        observableExpectation.expectedFulfillmentCount = 2
        var lastestState: Delayed<String, String, String>.State?
        let cancellable = sut.state.sink { _ in
            // Nothing to do here
        } receiveValue: { value in
            lastestState = value
            observableExpectation.fulfill()
        }

        sut.load()

        wait(for: [observableExpectation], timeout: 0.01)

        sut._assert(
            state: lastestState!
        )
        cancellable.cancel()
    }

    // MARK: - complete

    func test_complete_callsObservableStateWithLoadedState() throws {
        let sut: Delayed<String, String, String> = .async({ instance in
            instance.complete("loaded")
        })

        let observableExpectation = self.expectation(description: "")
        observableExpectation.expectedFulfillmentCount = 1
        var lastestState: Delayed<String, String, String>.State?
        let cancellable = sut.state.sink { _ in
            // Nothing to do here
        } receiveValue: { value in
            lastestState = value
            observableExpectation.fulfill()
        }

        sut.load()

        wait(for: [observableExpectation], timeout: 0.01)

        sut._assert(
            state: lastestState!
        )
        cancellable.cancel()
    }

    // MARK: - fail

    func test_fail_callsObservableStateWithLoadingFailedState() throws {
        let sut: Delayed<String, String, String> = .async({ instance in
            instance.fail("failed", onFailureOption: "retry")
        })

        let observableExpectation = self.expectation(description: "")
        observableExpectation.expectedFulfillmentCount = 1
        var lastestState: Delayed<String, String, String>.State?
        let cancellable = sut.state.sink { _ in
            // Nothing to do here
        } receiveValue: { value in
            lastestState = value
            observableExpectation.fulfill()
        }

        sut.load()

        wait(for: [observableExpectation], timeout: 0.01)

        sut._assert(
            state: lastestState!
        )
        cancellable.cancel()
    }
}
