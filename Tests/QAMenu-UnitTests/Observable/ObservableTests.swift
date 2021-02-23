//
//  ObservableTests.swift
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

import XCTest
@testable import QAMenu

class ObservableTests: XCTestCase {

    var sut: Observable<String>!

    override func setUpWithError() throws {
        self.sut = Observable<String>("initial")
    }

    override func tearDownWithError() throws {
        self.sut = nil
    }

    // MARK: - Observe

    func test_observe_returnsDisposable() throws {
        let disposable: Disposable = sut.observe { value in
            print(value)
        }
        XCTAssert(true, "observing the value returns a disposable \(disposable) without crashing")
    }

    func test_observe_addsObserverToObserversList_whenListIsEmpty() throws {
        XCTAssertEqual(self.sut.observers.isEmpty, true, "there should be no observers if the observable was initialized")

        _ = self.sut.observe { _ in }
        XCTAssertEqual(self.sut.observers.count, 1)
    }

    func test_observe_addsObserverToObserversList_whenListAlreadyContainsObservers() throws {
        _ = self.sut.observe { _ in }
        XCTAssertEqual(self.sut.observers.count, 1)

        _ = self.sut.observe { _ in }
        XCTAssertEqual(self.sut.observers.count, 2)
    }

    func test_observe_whenNotSkippingInitialValue_callsObserver() throws {
        let sut = Observable<String>("initial")

        let observationExpectation = expectation(description: "observer is called")
        observationExpectation.assertForOverFulfill = true
        _ = sut.observe(skipInitialValue: false) { value in
            observationExpectation.fulfill()
            XCTAssertEqual(value, "initial")
        }

        wait(for: [observationExpectation], timeout: 0.01)
    }

    func test_observe_whenSkippingInitialValue_doesNotCallsObserver() throws {
        let sut = Observable<String>("initial")

        let observationExpectation = expectation(description: "observer is not called")
        observationExpectation.isInverted = true
        _ = sut.observe(skipInitialValue: true) { _ in
            observationExpectation.fulfill()
        }

        wait(for: [observationExpectation], timeout: 0.01)
    }

    // MARK: - Update

    func test_update_doesNotCrash_whenHaving0Observers() throws {
        self.sut.update(with: "")

        XCTAssert(true, "updating the value without observers didn't crash")
    }

    func test_update_callsAllObserversExactlyOnce_whenHaving1Observer() throws {
        let expectedString = "abc"
        let observationTuple = makeObservation(expectedValue: expectedString)

        self.sut.update(with: expectedString)

        wait(for: [observationTuple.expectation], timeout: 0.01)
    }

    func test_update_callsAllObserversExactlyOnce_whenHaving2Observer() throws {
        let expectedString = "def"
        let observation1Tuple = makeObservation(expectedValue: expectedString)
        let observation2Tuple = makeObservation(expectedValue: expectedString)

        self.sut.update(with: expectedString)

        let expectations = [
            observation1Tuple.expectation,
            observation2Tuple.expectation
        ]
        wait(for: expectations, timeout: 0.01)
    }

    func test_update_callsAllObserversExactlyOnce_whenHaving2Observer_withInvertedExpectation() throws {
        // Make sure that the expectation is actually comparing the string by having one inverted assertion
        let observation1Tuple = makeObservation(expectedValue: "false")
        observation1Tuple.expectation.isInverted = true
        let observation2Tuple = makeObservation(expectedValue: "true")

        self.sut.update(with: "true")

        let expectations = [
            observation1Tuple.expectation,
            observation2Tuple.expectation
        ]
        wait(for: expectations, timeout: 0.01)
    }

    func test_update_callsAllObserversAgain_whenHaving1Observer_andUpdatingTheValue2Times() throws {
        let observationTuple = makeObservation(
            expectedValues: [
                "first",
                "second"
            ]
        )

        self.sut.update(with: "first")
        self.sut.update(with: "second")

        wait(for: [observationTuple.expectation], timeout: 0.01)
    }

    func test_updateWithNilIsAvailable_whenTypeIsOptional() throws {
        let sut = Observable<Int?>(0)

        sut.update(with: nil)

        XCTAssert(true, "update with a nil value is available if the wrapped value type is an Optional")
    }

    func test_update_whenNotSkippingInitialValue_callsAllObserversTwice() throws {
        let sut = Observable<String>("initial")

        let observationExpectation = expectation(description: "observer is called")
        observationExpectation.expectedFulfillmentCount = 2
        observationExpectation.assertForOverFulfill = true
        _ = sut.observe(skipInitialValue: false) { _ in
            observationExpectation.fulfill()
        }

        sut.update(with: "update")

        wait(for: [observationExpectation], timeout: 0.01)
    }

    func test_update_whenSkippingInitialValue_callsAllObserversExactlyOnce() throws {
        let sut = Observable<String>("initial")

        let observationExpectation = expectation(description: "observer is called")
        observationExpectation.assertForOverFulfill = true
        _ = sut.observe(skipInitialValue: true) { _ in
            observationExpectation.fulfill()
        }

        sut.update(with: "update")

        wait(for: [observationExpectation], timeout: 0.01)
    }

    // MARK: - Dispose

    func test_observerIsRemoved_whenDisposed() {
        let disposable1 = self.sut.observe({ _ in })
        _ = self.sut.observe({ _ in })

        XCTAssertEqual(self.sut.observers.count, 2)

        disposable1.dispose()

        XCTAssertEqual(self.sut.observers.count, 1)
    }

    func test_observerIsNotExecuted_whenDisposed() {
        let observationExpectation = expectation(description: "observer is not called after calling dispose")
        observationExpectation.isInverted = true
        let disposable = self.sut.observe(skipInitialValue: true) { _ in
            observationExpectation.fulfill()
        }

        disposable.dispose()
        self.sut.update(with: "abc")

        wait(for: [observationExpectation], timeout: 0.01)
    }

    // MARK: - Helper

    private func makeObservation(expectedValue: String) -> (disposable: Disposable, expectation: XCTestExpectation) {
        return makeObservation(expectedValues: [expectedValue])
    }

    private func makeObservation(
        expectedValues: [String]
    ) -> (disposable: Disposable, expectation: XCTestExpectation) {
        let observationExpectation = expectation(description: "observer is called")
        observationExpectation.expectedFulfillmentCount = expectedValues.count
        var expectedValues = expectedValues
        let disposable = self.sut.observe(skipInitialValue: true) { value in
            if value == expectedValues[0] {
                observationExpectation.fulfill()
            }
            expectedValues.removeFirst()
        }
        return (disposable: disposable, expectation: observationExpectation)
    }
}
