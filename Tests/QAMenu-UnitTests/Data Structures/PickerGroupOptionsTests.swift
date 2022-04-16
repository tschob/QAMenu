//
//  PickerGroupOptionsTests.swift
//
//  Created by Hans Seiffert on 22.02.21.
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
import XCTest

@testable import QAMenu

class PickerGroupOptionsTests: XCTestCase {

    // MARK: - initialized

    func test_unboxedItems_whenStateIsInitialized_returnsEmptyArray() throws {
        let sut = PickerGroupOptions({ delayed in
            delayed.complete([
                MockPickableItem()
            ])
        })

        XCTAssertTrue(sut.unboxedItems.isEmpty)
    }

    func test_unboxedOptions_whenStateIsInitialized_returnsNil() throws {
        let sut = PickerGroupOptions({ delayed in
            delayed.complete([
                MockPickableItem()
            ])
        })

        XCTAssertNil(sut.unboxedOptions)
    }

    // MARK: - loading

    func test_unboxedItems_whenStateIsLoading_andNoProgressSet_returnsEmptyArray() throws {
        let sut = PickerGroupOptions({ delayed in
            delayed.updateProgress(nil)
        })
        sut.load()

        XCTAssertTrue(sut.unboxedItems.isEmpty)
    }

    func test_unboxedOptions_whenStateIsLoading_andNoProgressSet_returnsNil() throws {
        let sut = PickerGroupOptions({ delayed in
            delayed.updateProgress(nil)
        })
        sut.load()

        XCTAssertNil(sut.unboxedOptions)
    }

    func test_unboxedItems_whenStateIsLoading_andProgressSet_returnsProgress() throws {
        let progress = ProgressItem(state: .progress("progress"))
        let sut = PickerGroupOptions({ delayed in
            delayed.updateProgress(progress)
        })
        sut.load()

        XCTAssertEqual(sut.unboxedItems.count, 1)
        let progressItem = sut.unboxedItems[safe: 0] as? ProgressItem
        if case .progress("progress") = progressItem?.state {
            XCTAssertTrue(true, "\(String(describing: progressItem)) == \(progress.state)")
        } else {
            XCTFail("\(String(describing: progressItem)) != \(progress.state)")
        }
    }

    func test_unboxedOptions_whenStateIsLoading_andProgressSet_returnsNil() throws {
        let progress = ProgressItem(state: .progress("progress"))
        let sut = PickerGroupOptions({ delayed in
            delayed.updateProgress(progress)
        })
        sut.load()

        XCTAssertNil(sut.unboxedOptions)
    }

    // MARK: - loaded

    func test_unboxedItems_whenStateIsLoaded_returnsOptions() throws {
        let items = [
            MockPickableItem(),
            MockPickableItem()
        ]
        let sut = PickerGroupOptions({ delayed in
            delayed.complete(items)
        })
        sut.load()

        XCTAssertEqual(sut.unboxedItems.count, 2)
        XCTAssertEqual(sut.unboxedItems[0] as? MockPickableItem, items[0])
        XCTAssertEqual(sut.unboxedItems[1] as? MockPickableItem, items[1])
    }

    func test_unboxedOptions_whenStateIsLoaded_returnsOptions() throws {
        let items = [
            MockPickableItem(),
            MockPickableItem()
        ]
        let sut = PickerGroupOptions({ delayed in
            delayed.complete(items)
        })
        sut.load()

        XCTAssertEqual(sut.unboxedOptions?.count, 2)
        XCTAssertEqual(sut.unboxedOptions?[0] as? MockPickableItem, items[0])
        XCTAssertEqual(sut.unboxedOptions?[1] as? MockPickableItem, items[1])
    }

    func test_unboxedItems_whenStateIsLoaded_returnsEmptyArray() throws {
        let sut = PickerGroupOptions({ delayed in
            delayed.complete([])
        })
        sut.load()

        XCTAssertTrue(sut.unboxedItems.isEmpty)
    }

    func test_unboxedOptions_whenStateIsLoaded_returnsEmptyArray() throws {
        let sut = PickerGroupOptions({ delayed in
            delayed.complete([])
        })
        sut.load()

        XCTAssertTrue(sut.unboxedItems.isEmpty)
    }

    // MARK: - loadingFailed

    func test_unboxedItems_whenStateIsLoadingFailed_returnsProgress() throws {
        let progress = ProgressItem(state: .failure("failure"))
        let retryButton = ButtonItem(title: .static("button")) { _ in }
        let sut = PickerGroupOptions({ delayed in
            delayed.fail(progress, onFailureOption: retryButton)
        })
        sut.load()

        XCTAssertEqual(sut.unboxedItems.count, 2)
        let progressItem = sut.unboxedItems[safe: 0] as? ProgressItem
        if case .failure("failure") = progressItem?.state {
            XCTAssertTrue(true, "\(String(describing: progressItem)) == \(progress.state)")
        } else {
            XCTFail("\(String(describing: progressItem)) != \(progress.state)")
        }
        XCTAssertEqual((sut.unboxedItems[1] as? ButtonItem)?.title.unboxed, "button")
    }

    func test_unboxedOptions_whenStateIsLoadingFailed_returnsProgress() throws {
        let progress = ProgressItem(state: .failure("failure"))
        let retryButton = ButtonItem(title: .static("button")) { _ in }
        let sut = PickerGroupOptions({ delayed in
            delayed.fail(progress, onFailureOption: retryButton)
        })
        sut.load()

        XCTAssertNil(sut.unboxedOptions)
    }

    func test_unboxedItems_whenStateIsLoadingFailed_andProgress_returnsProgressAndOnFailureOption() throws {
        let progress = ProgressItem(state: .failure("failure"))
        let sut = PickerGroupOptions({ delayed in
            delayed.fail(progress, onFailureOption: nil)
        })
        sut.load()

        XCTAssertEqual(sut.unboxedItems.count, 1)
        let progressItem = sut.unboxedItems[safe: 0] as? ProgressItem
        if case .failure("failure") = progressItem?.state {
            XCTAssertTrue(true, "\(String(describing: progressItem)) == \(progress.state)")
        } else {
            XCTFail("\(String(describing: progressItem)) != \(progress.state)")
        }
    }

    func test_unboxedItems_whenStateIsLoadingFailed_andHavingOnlyOnFailureOption_returnsProgressAndOnFailureOption() throws {
        let retryButton = ButtonItem(title: .static("button")) { _ in }
        let sut = PickerGroupOptions({ delayed in
            delayed.fail(nil, onFailureOption: retryButton)
        })
        sut.load()

        XCTAssertEqual(sut.unboxedItems.count, 1)
        XCTAssertEqual((sut.unboxedItems[0] as? ButtonItem)?.title.unboxed, "button")
    }

    func test_unboxedItems_whenStateIsLoadingFailed_andHavingNoProgressNorOnFailureOption_returnsEmptyArray() throws {
        let sut = PickerGroupOptions({ delayed in
            delayed.fail(nil, onFailureOption: nil)
        })
        sut.load()

        XCTAssertTrue(sut.unboxedItems.isEmpty)
    }

    func test_unboxedOptions_whenStateIsLoadingFailed_andHavingNoProgressNorOnFailureOption_returnsNil() throws {
        let sut = PickerGroupOptions({ delayed in
            delayed.fail(nil, onFailureOption: nil)
        })
        sut.load()

        XCTAssertNil(sut.unboxedOptions)
    }
}
