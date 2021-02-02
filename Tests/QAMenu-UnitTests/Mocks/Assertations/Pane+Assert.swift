//
//  Pane+Assert.swift
//
//  Created by Hans Seiffert on 31.01.21.
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

extension Pane {

    // MARK: - Items

    internal static func _assertInitProperties(
        _ _sut: Pane,
        title: String? = nil,
        items: [MockItem],
        isSearchable: Bool = false,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let _itemGroup = _sut.groups[0]
        ItemGroup._assertInitProperties(
            _itemGroup as! ItemGroup,
            title: nil,
            items: items,
            footerText: nil
        )
        self._assertInitProperties(
            _sut,
            title: title,
            isSearchable: isSearchable
        )
    }

    // MARK: - ItemGroup

    internal static func _assertInitProperties(
        _ _sut: Pane,
        title: String? = nil,
        itemGroups: [ItemGroup],
        isSearchable: Bool = false,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        var groupIndex = 0
        itemGroups.forEach { itemGroup in
            let _itemGroup = _sut.groups[groupIndex]
            ItemGroup._assertInitProperties(
                _itemGroup as! ItemGroup,
                title: itemGroup.title?(),
                items: itemGroup.items as! [MockItem],
                footerText: itemGroup.footerText?()
            )
            groupIndex += 1
        }
        self._assertInitProperties(
            _sut,
            title: title,
            isSearchable: isSearchable
        )
    }

    // MARK: - PickerGroup

    internal static func _assertInitProperties(
        _ _sut: Pane,
        title: String? = nil,
        pickerGroups: [PickerGroup],
        footerText: String? = nil,
        onPickedOptionFailure: String,
        isSearchable: Bool = false,
        testCase: XCTestCase,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        var groupIndex = 0
        pickerGroups.forEach { pickerGroup in
            let _pickerGroup = _sut.groups[groupIndex] as! PickerGroup
            PickerGroup._assertInitProperties(
                _pickerGroup,
                title: pickerGroup.title?.unboxed,
                options: pickerGroup.options as! [MockPickableItem],
                footerText: pickerGroup.footerText?.unboxed,
                onPickedOptionFailure: onPickedOptionFailure,
                testCase: testCase
            )
            groupIndex += 1
        }
        self._assertInitProperties(
            _sut,
            title: title,
            isSearchable: isSearchable
        )
    }

    // MARK: - Base

    private static func _assertInitProperties(
        _ _sut: Pane,
        title: String? = nil,
        isSearchable: Bool = false,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        XCTAssertEqual(_sut.title.unboxed, title, file: file, line: line)
        XCTAssertEqual(_sut.isSearchable, isSearchable, file: file, line: line)
    }
}
