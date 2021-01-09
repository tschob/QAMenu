//
//  ObservableEventTests.swift
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
@testable import QAMenu

class ObservableEventTests: XCTestCase {

    var sut: ObservableEvent<String> = ObservableEvent<String>()

    override func setUpWithError() throws {
        self.sut = ObservableEvent<String>()
    }

    // MARK: - Observe

    func test_observe_returnsDisposable() throws {
        let disposable: Disposable = sut.observe { value in
            print(value)
        }
        XCTAssert(true, "observing the event returns a disposable \(disposable)")
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

    // MARK: - Fire

    func test_fire_doesNotCrash_whenHaving0Observers() throws {
        self.sut.fire(with: "")

        XCTAssert(true, "firing an event without observers didn't crash")
    }

    func test_fire_callsAllObserversExactlyOnce_whenHaving1Observer() throws {
        let expectedString = "abc"
        let observationTuple = makeObservation(expectedEvent: expectedString)

        self.sut.fire(with: expectedString)

        wait(for: [observationTuple.expectation], timeout: 0.01)
    }

    func test_fire_callsAllObserversExactlyOnce_whenHaving2Observer() throws {
        let expectedString = "def"
        let observation1Tuple = makeObservation(expectedEvent: expectedString)
        let observation2Tuple = makeObservation(expectedEvent: expectedString)

        self.sut.fire(with: expectedString)

        let expectations = [
            observation1Tuple.expectation,
            observation2Tuple.expectation
        ]
        wait(for: expectations, timeout: 0.01)
    }

    func test_fire_callsAllObserversExactlyOnce_whenHaving2Observer_withInvertedExpectation() throws {
        // Make sure that the expectation is actually comparing the string by having one inverted assertation
        let observation1Tuple = makeObservation(expectedEvent: "false")
        observation1Tuple.expectation.isInverted = true
        let observation2Tuple = makeObservation(expectedEvent: "true")

        self.sut.fire(with: "true")

        let expectations = [
            observation1Tuple.expectation,
            observation2Tuple.expectation
        ]
        wait(for: expectations, timeout: 0.01)
    }

    func test_fire_callsAllObserversAgain_whenHaving1Observer_andFiringTheEvent2Times() throws {
        let observationTuple = makeObservation(
            expectedEvents: [
                "first",
                "second"
            ]
        )

        self.sut.fire(with: "first")
        self.sut.fire(with: "second")

        wait(for: [observationTuple.expectation], timeout: 0.01)
    }

    func test_fireWithoutParametersIsAvailable_whenEventIsOfTypeVoid() throws {
        let sut = ObservableEvent<Void>()

        sut.fire()

        XCTAssert(true, "fire without event is available if the event type is Void")
    }

    func test_fireWithoutParameters_callsAllObserversExactlyOnce_whenEventIsOfTypeVoid() throws {
        let sut = ObservableEvent<Void>()

        let observationExpectation = expectation(description: "observer is called")
        observationExpectation.assertForOverFulfill = true
        _ = sut.observe { _ in
            observationExpectation.fulfill()
        }

        sut.fire()

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
        let observationExpectation = expectation(description: "observer is not called calling dispose")
        observationExpectation.isInverted = true
        let disposable = self.sut.observe({ _ in
            observationExpectation.fulfill()
        })

        disposable.dispose()
        self.sut.fire(with: "abc")

        wait(for: [observationExpectation], timeout: 0.01)
    }

    // MARK: - Helper

    private func makeObservation(expectedEvent: String) -> (disposable: Disposable, expectation: XCTestExpectation) {
        return makeObservation(expectedEvents: [expectedEvent])
    }

    private func makeObservation(expectedEvents: [String]) -> (disposable: Disposable, expectation: XCTestExpectation) {
        let observationExpectation = expectation(description: "observer is called")
        observationExpectation.expectedFulfillmentCount = expectedEvents.count
        var expectedEvents = expectedEvents
        let disposable = self.sut.observe { value in
            if value == expectedEvents[0] {
                observationExpectation.fulfill()
            }
            expectedEvents.removeFirst()
        }
        return (disposable: disposable, expectation: observationExpectation)
    }
}
