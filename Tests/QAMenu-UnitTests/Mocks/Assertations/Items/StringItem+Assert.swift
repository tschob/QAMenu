//
//  StringItem+Assert.swift
//
//  Created by Hans Seiffert on 01.02.21.
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
import QAMenu

extension StringItem {

    internal static func _assertInitProperties(
        _ _sut: StringItem,
        title: String? = nil,
        value: String? = nil,
        footerText: String? = nil,
        fallbackString: String? = "<nil>",
        layoutType: StringItem.LayoutType? = .horizontal(.singleLine),
        titleTextAttributes: TextAttributes = TextAttributes(textStyle: .body, lineBreak: .wrapByWord),
        valueTextAttributes: TextAttributes = TextAttributes(textStyle: .body, lineBreak: .wrapByWord),
        file: StaticString = #file,
        line: UInt = #line
    ) {
        XCTAssertEqual(_sut.title?.unboxed, title, file: file, line: line)
        XCTAssertEqual(_sut.value?.unboxed, value, file: file, line: line)
        XCTAssertEqual(_sut.footerText?.unboxed, footerText, file: file, line: line)
        XCTAssertEqual(_sut.valueFallbackString, fallbackString, file: file, line: line)
        XCTAssertEqual(_sut.layoutType.unboxed, layoutType, file: file, line: line)
        XCTAssertEqual(_sut.titleTextAttributes.unboxed, titleTextAttributes, file: file, line: line)
        XCTAssertEqual(_sut.valueTextAttributes.unboxed, valueTextAttributes, file: file, line: line)
    }
}
