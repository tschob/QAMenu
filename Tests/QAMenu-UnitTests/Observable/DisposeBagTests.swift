//
//  DisposeBagTests.swift
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

class DisposeBagTests: XCTestCase {

    var sut: DisposeBag = DisposeBag()

    override func setUpWithError() throws {
        self.sut = DisposeBag()
    }

    func test_add_addsDisposableToBag_whenEmpty() throws {
        let disposable = Disposable {}

        self.sut.add(disposable)

        XCTAssert(self.sut.disposables.contains(where: { $0 === disposable }))
        XCTAssertEqual(self.sut.disposables.count, 1)
    }

    func test_add_addsDisposableToBag_whenNotEmpty() throws {
        let disposable1 = Disposable {}
        self.sut.add(disposable1)

        let disposable2 = Disposable {}
        self.sut.add(disposable2)

        XCTAssert(self.sut.disposables.contains(where: { $0 === disposable1 }))
        XCTAssert(self.sut.disposables.contains(where: { $0 === disposable2 }))
        XCTAssertEqual(self.sut.disposables.count, 2)
    }

    func test_dispose_disposesDisposables_whenHavingOneDisposable() throws {
        let disposableTuple = makeDisposable()
        self.sut.add(disposableTuple.disposable)

        self.sut.dispose()

        wait(for: [disposableTuple.expectation], timeout: 0.01)

        XCTAssertEqual(self.sut.disposables.isEmpty, true, "disposable should be removed after they are disposed")
    }

    func test_dispose_callsDispose_whenHavingTwoDisposables() throws {
        let disposable1Tuple = makeDisposable()
        let disposable2Tuple = makeDisposable()
        self.sut.add(disposable1Tuple.disposable)
        self.sut.add(disposable2Tuple.disposable)

        self.sut.dispose()

        let expectations = [
            disposable1Tuple.expectation,
            disposable2Tuple.expectation
        ]
        wait(for: expectations, timeout: 0.01)

        XCTAssertTrue(self.sut.disposables.isEmpty)
    }

    func test_dispose_removesDisposables_whenHavingOneDisposable() throws {
        self.sut.add(Disposable({}))

        self.sut.dispose()

        XCTAssertEqual(self.sut.disposables.isEmpty, true, "disposable should be removed after they are disposed")
    }

    func test_dispose_removesDisposables_whenHavingTwoDisposables() throws {
        self.sut.add(Disposable {})
        self.sut.add(Disposable {})

        self.sut.dispose()

        XCTAssertTrue(self.sut.disposables.isEmpty)
    }

    // MARK: - Helper

    private func makeDisposable() -> (disposable: Disposable, expectation: XCTestExpectation) {
        let disposeExpectation = expectation(description: "disposable is getting disposed")
        // Calling `dispose` should only dispose once
        disposeExpectation.assertForOverFulfill = true
        let disposable = Disposable({
            disposeExpectation.fulfill()
        })
        return (disposable: disposable, expectation: disposeExpectation)
    }
}
