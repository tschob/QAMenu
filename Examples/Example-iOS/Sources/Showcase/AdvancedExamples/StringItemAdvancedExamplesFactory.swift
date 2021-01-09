//
//  StringItemAdvancedExamplesFactory.swift
//
//  Created by Hans Seiffert on 20.05.20.
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

import QAMenu

struct StringItemAdvancedExamplesFactory {

    static func makePane() -> Pane {
        let pane = Pane(
            title: .static("StringItem"),
            groups: [
                self.makeGroup(layoutType: .horizontal(.singleLine), title: "Layout: horizontal(.singleLine)"),
                self.makeGroup(layoutType: .horizontal(.autoGrow), title: "Layout: horizontal(.autoGrow)"),
                self.makeGroup(layoutType: .vertical(.singleLine), title: "Layout: vertical(.singleLine)"),
                self.makeGroup(layoutType: .vertical(.autoGrow), title: "Layout: vertical(.autoGrow)")
            ],
            isSearchable: true
        )
        return pane
    }

    private static func makeGroup(layoutType: StringItem.LayoutType, title: String) -> ItemGroup {
        let stringItems = ItemGroup(
            title: .computed({ title }),
            items: [
                StringItem(
                    title: .static("Title (short)"),
                    value: .static("Value"),
                    layoutType: .static(layoutType)
                ),
                StringItem(
                    title: .static("Title (short)"),
                    value: .static("Value"),
                    footerText: .static("A StringItem can be long pressed to share it's value"),
                    layoutType: .static(layoutType)
                ),
                StringItem(
                    title: .static("Title (short)"),
                    value: .static("Value (medium length)"),
                    footerText: .static("A StringItem can be long pressed to share it's value"),
                    layoutType: .static(layoutType)
                ),
                StringItem(
                    title: .static("Title (with a medium length)"),
                    value: .static("Value (medium length)"),
                    footerText: .static("A StringItem can be long pressed to share it's value"),
                    layoutType: .static(layoutType)
                ),
                StringItem(
                    title: .static("Title (with a medium length)"),
                    value: .static("Value"),
                    footerText: .static("A StringItem can be long pressed to share it's value"),
                    layoutType: .static(layoutType)
                ),
                StringItem(
                    title: .static("Title (with a medium length)"),
                    value: .static("Value (medium length)"),
                    footerText: .static("A StringItem can be long pressed to share it's value"),
                    layoutType: .static(layoutType)
                ),
                StringItem(
                    title: .static("Title (with a very extensive and long length)"),
                    value: .static("Value (with a very extensive and long length)"),
                    footerText: .static("A StringItem can be long pressed to share it's value"),
                    layoutType: .static(layoutType)
                )
            ]
        )
        return stringItems
    }
}
