//
//  Array+SafeTests.swift
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

class Array_SafeTests: XCTestCase {

    struct Arrays {
        static let empty = [Int]()
        static let oneItem = [1]
        static let multipleItems = [1, 2, 3, 4, 5]
    }

    // MARK: - Empty Array

    func test_safe_given0_whenArrayHas0Items_returnsNil() throws {
        XCTAssertNil(Arrays.empty[safe: 0])
    }

    func test_safeWithDefault_given0_whenArrayHas0Items_returnsDefault() throws {
        XCTAssertEqual(Arrays.empty[safe: 0, default: 9], 9)
    }

    func test_safe_given3_whenArrayHas0Items_returnsNil() throws {
        XCTAssertNil(Arrays.empty[safe: 3])
    }

    func test_safeWithDefault_given3_whenArrayHas0Items_returnsDefault() throws {
        XCTAssertEqual(Arrays.empty[safe: 3, default: 9], 9)
    }

    // MARK: - One Item Array

    func test_safe_given0_whenArrayHas1Item_returnsItem() throws {
        XCTAssertEqual(Arrays.oneItem[safe: 0], 1)
    }

    func test_safeWithDefault_given0_whenArrayHas1Item_returnsItem() throws {
        XCTAssertEqual(Arrays.oneItem[safe: 0, default: 9], 1)
    }

    func test_safe_given1_whenArrayHas1Item_returnsNil() throws {
        XCTAssertNil(Arrays.oneItem[safe: 1])
    }

    func test_safeWithDefault_given1_whenArrayHas1Item_returnsDefault() throws {
        XCTAssertEqual(Arrays.oneItem[safe: 1, default: 9], 9)
    }

    func test_safe_given3_whenArrayHas1Item_returnsNil() throws {
        XCTAssertNil(Arrays.oneItem[safe: 3])
    }

    func test_safeWithDefault_given3_whenArrayHas1Item_returnsDefault() throws {
        XCTAssertEqual(Arrays.oneItem[safe: 3, default: 9], 9)
    }

    // MARK: - Multiple items Array

    func test_safe_given0_whenArrayHas5Items_returnsItem() throws {
        XCTAssertEqual(Arrays.multipleItems[safe: 0], 1)
    }

    func test_safeWithDefault_given0_whenArrayHas5Items_returnsItem() throws {
        XCTAssertEqual(Arrays.multipleItems[safe: 0, default: 9], 1)
    }

    func test_safe_given3_whenArrayHas5Items_returnsItem() throws {
        XCTAssertEqual(Arrays.multipleItems[safe: 3], 4)
    }

    func test_safeWithDefault_given3_whenArrayHas5Items_returnsItem() throws {
        XCTAssertEqual(Arrays.multipleItems[safe: 3, default: 9], 4)
    }

    func test_safe_given4_whenArrayHas5Items_returnsItem() throws {
        XCTAssertEqual(Arrays.multipleItems[safe: 4], 5)
    }

    func test_safeWithDefault_given4_whenArrayHas5Items_returnsItem() throws {
        XCTAssertEqual(Arrays.multipleItems[safe: 4, default: 9], 5)
    }

    func test_safe_given5_whenArrayHas5Items_returnsNil() throws {
        XCTAssertNil(Arrays.multipleItems[safe: 5])
    }

    func test_safeWithDefault_given5_whenArrayHas5Items_returnsDefault() throws {
        XCTAssertEqual(Arrays.multipleItems[safe: 5, default: 9], 9)
    }

    func test_safe_given10_whenArrayHas5Items_returnsNil() throws {
        XCTAssertNil(Arrays.multipleItems[safe: 10])
    }

    func test_safeWithDefault_given10_whenArrayHas5Items_returnsDefault() throws {
        XCTAssertEqual(Arrays.multipleItems[safe: 10, default: 9], 9)
    }
}
