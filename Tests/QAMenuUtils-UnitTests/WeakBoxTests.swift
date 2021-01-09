//
//  WeakBoxTests.swift
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
import QAMenuUtils

class WeakBoxTests: XCTestCase {

    var object: NSObject?

    override func setUpWithError() throws {
        object = NSObject()
    }

    override func tearDownWithError() throws {
        object = nil
    }

    func test_unbox_whenObjectIsStronglyInitialized_returnsObject() throws {
        let weakBox = WeakBox(self.object!)
        XCTAssertEqual(weakBox.unbox, object, "the unboxed value should be the object as it is still strongly referenced")
    }

    func test_unbox_whenObjectIsNotStronglyReferenced_returnsNil() throws {
        let weakBox = WeakBox(self.object!)
        self.object = nil
        XCTAssertEqual(weakBox.unbox, nil, "the unboxed value should be nil as it was not strongly referenced anymore")
    }

    func test_unbox_whenObjectIsReferencedAgain_returnsNil() throws {
        let weakBox = WeakBox(self.object!)
        self.object = NSObject()
        XCTAssertEqual(weakBox.unbox, nil, "should be nil as it's a box, not a weak reference to the given property")
    }
}
