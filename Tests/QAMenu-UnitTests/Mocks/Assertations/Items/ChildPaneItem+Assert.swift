//
//  ChildPaneItem+Assert.swift
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

extension ChildPaneItem {

    // MARK: - Pane

    internal static func _assertInitProperties(
        _ _sut: ChildPaneItem,
        pane: Pane,
        title: String? = nil,
        value: String? = nil,
        footerText: String? = nil,
        fallbackString: String = "",
        layoutType: StringItem.LayoutType = .horizontal(.singleLine),
        titleTextAttributes: TextAttributes = TextAttributes(textStyle: .body, lineBreak: .wrapByWord),
        valueTextAttributes: TextAttributes = TextAttributes(textStyle: .body, lineBreak: .wrapByWord),
        file: StaticString = #file,
        line: UInt = #line
    ) {
        if case .navigationWithPane(let paneClosure, _) = _sut.selectionOutcome,
           paneClosure() == pane {
            XCTAssert(true)
        } else {
            XCTFail("\(_sut.selectionOutcome) doesn't equal a navigation to \(pane)")
        }
        self._assertInitProperties(
            _sut,
            title: title,
            value: value,
            footerText: footerText,
            fallbackString: fallbackString,
            layoutType: layoutType,
            titleTextAttributes: titleTextAttributes,
            valueTextAttributes: valueTextAttributes
        )
    }

    // MARK: - PaneRepresntable

    internal static func _assertInitProperties(
        _ sut: ChildPaneItem,
        paneRepresentable: MockPaneRepresentable,
        title: String? = nil,
        value: String? = nil,
        footerText: String? = nil,
        fallbackString: String = "",
        layoutType: StringItem.LayoutType = .horizontal(.singleLine),
        titleTextAttributes: TextAttributes = TextAttributes(textStyle: .body, lineBreak: .wrapByWord),
        valueTextAttributes: TextAttributes = TextAttributes(textStyle: .body, lineBreak: .wrapByWord),
        file: StaticString = #file,
        line: UInt = #line
    ) {
        if case .navigationWithPaneRepresentable(let paneRepresentableClosure, _) = sut.selectionOutcome,
           paneRepresentableClosure() as! MockPaneRepresentable == paneRepresentable {
            XCTAssert(true)
        } else {
            XCTFail("\(sut.selectionOutcome) doesn't equal a navigation to \(paneRepresentable)")
        }
        self._assertInitProperties(
            sut,
            title: title,
            value: value,
            footerText: footerText,
            fallbackString: fallbackString,
            layoutType: layoutType,
            titleTextAttributes: titleTextAttributes,
            valueTextAttributes: valueTextAttributes
        )
    }

    // MARK: - Items

    internal static func _assertInitProperties(
        _ _sut: ChildPaneItem,
        items: [MockItem],
        title: String? = nil,
        value: String? = nil,
        footerText: String? = nil,
        fallbackString: String = "",
        isPaneReloadable: Bool = false,
        isPaneSearchable: Bool = false,
        layoutType: StringItem.LayoutType = .horizontal(.singleLine),
        titleTextAttributes: TextAttributes = TextAttributes(textStyle: .body, lineBreak: .wrapByWord),
        valueTextAttributes: TextAttributes = TextAttributes(textStyle: .body, lineBreak: .wrapByWord),
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let pane: Pane! = {
            if case .pane(let paneClosure) = _sut.childType {
                return paneClosure()
            } else {
                XCTFail("childPane should be of type .pane(...)")
                return nil
            }
        }()
        Pane._assertInitProperties(
            pane,
            title: pane.title.unboxed,
            items: items,
            isReloadable: isPaneReloadable,
            isSearchable: isPaneSearchable
        )
        self._assertInitProperties(
            _sut,
            title: title,
            value: value,
            footerText: footerText,
            fallbackString: fallbackString,
            layoutType: layoutType,
            titleTextAttributes: titleTextAttributes,
            valueTextAttributes: valueTextAttributes
        )
    }

    // MARK: - ItemGroups

    internal static func _assertInitProperties(
        _ _sut: ChildPaneItem,
        itemGroups: [MockGroup],
        title: String? = nil,
        value: String? = nil,
        footerText: String? = nil,
        fallbackString: String = "",
        isPaneReloadable: Bool = false,
        isPaneSearchable: Bool = false,
        layoutType: StringItem.LayoutType = .horizontal(.singleLine),
        titleTextAttributes: TextAttributes = TextAttributes(textStyle: .body, lineBreak: .wrapByWord),
        valueTextAttributes: TextAttributes = TextAttributes(textStyle: .body, lineBreak: .wrapByWord),
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let pane: Pane! = {
            if case .pane(let paneClosure) = _sut.childType {
                return paneClosure()
            } else {
                XCTFail("childPane should be of type .pane(...)")
                return nil
            }
        }()

        XCTAssertEqual(pane.groups.count, itemGroups.count, file: file, line: line)
        var groupIndex = 0
        itemGroups.forEach { itemGroup in
            let _itemGroup = pane.groups[groupIndex]
            XCTAssertEqual(
                _itemGroup.title?.unboxed,
                itemGroup.title?.unboxed,
                file: file,
                line: line
            )
            XCTAssertEqual(
                _itemGroup.items.unboxed.count,
                itemGroup.items.unboxed.count,
                file: file,
                line: line
            )
            var itemIndex = 0
            itemGroup.items.unboxed.forEach { item in
                XCTAssertEqual(
                    _itemGroup.items.unboxed[safe: itemIndex] as? MockItem,
                    item as? MockItem,
                    file: file,
                    line: line
                )
                itemIndex += 1
            }
            groupIndex += 1
        }
        self._assertInitProperties(
            _sut,
            title: title,
            value: value,
            footerText: footerText,
            fallbackString: fallbackString,
            layoutType: layoutType,
            titleTextAttributes: titleTextAttributes,
            valueTextAttributes: valueTextAttributes
        )
    }

    // MARK: - PickerGroups

    internal static func _assertInitProperties(
        _ _sut: ChildPaneItem,
        pickerGroups: [PickerGroup],
        title: String? = nil,
        value: String? = nil,
        footerText: String? = nil,
        fallbackString: String = "",
        isPaneReloadable: Bool = false,
        isPaneSearchable: Bool = false,
        layoutType: StringItem.LayoutType = .horizontal(.singleLine),
        titleTextAttributes: TextAttributes = TextAttributes(textStyle: .body, lineBreak: .wrapByWord),
        valueTextAttributes: TextAttributes = TextAttributes(textStyle: .body, lineBreak: .wrapByWord),
        onPickedOptionFailure: String,
        testCase: XCTestCase,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let pane: Pane! = {
            if case .pane(let paneClosure) = _sut.childType {
                return paneClosure()
            } else {
                XCTFail("childPane should be of type .pane(...)")
                return nil
            }
        }()

        XCTAssertEqual(pane.groups.count, pickerGroups.count, file: file, line: line)
        XCTAssertEqual(pane.isReloadable, isPaneReloadable, file: file, line: line)
        XCTAssertEqual(pane.isSearchable, isPaneSearchable, file: file, line: line)
        var groupIndex = 0
        pickerGroups.forEach { pickerGroup in
            let _pickerGroup = pane.groups[groupIndex] as! PickerGroup
            PickerGroup._assertInitProperties(
                _pickerGroup,
                title: pickerGroup.title?.unboxed,
                options: pickerGroup.options.unboxedOptions as? [MockPickableItem] ?? [],
                footerText: pickerGroup.footerText?.unboxed,
                onPickedOptionFailure: onPickedOptionFailure,
                testCase: testCase
            )
            groupIndex += 1
        }
        self._assertInitProperties(
            _sut,
            title: title,
            value: value,
            footerText: footerText,
            fallbackString: fallbackString,
            layoutType: layoutType,
            titleTextAttributes: titleTextAttributes,
            valueTextAttributes: valueTextAttributes
        )
    }

    // MARK: - Base

    private static func _assertInitProperties(
        _ _sut: ChildPaneItem,
        title: String? = nil,
        value: String? = nil,
        footerText: String? = nil,
        fallbackString: String = "",
        layoutType: StringItem.LayoutType = .horizontal(.singleLine),
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
