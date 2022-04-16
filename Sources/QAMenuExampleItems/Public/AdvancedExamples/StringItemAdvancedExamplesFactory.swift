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

import Foundation
import QAMenu

public struct StringItemAdvancedExamplesFactory {

    private struct TitleAttributes {
        static var textStyle: TextAttributes.TextStyle = .body
        static var lineBreak: TextAttributes.LineBreak = .wrapByWord

        static var combined: TextAttributes {
            return .init(textStyle: self.textStyle, lineBreak: self.lineBreak)
        }
    }

    private struct ValueAttributes {
        static var textStyle: TextAttributes.TextStyle = .body
        static var lineBreak: TextAttributes.LineBreak = .wrapByWord

        static var combined: TextAttributes {
            return .init(textStyle: self.textStyle, lineBreak: self.lineBreak)
        }
    }

    private static var pane: Pane!

    public static func makePane() -> Pane {
        self.pane = Pane(
            title: .static("StringItem"),
            groups: [
                self.makeTextAttributesGroup(),
                self.makeGroup(layoutType: .horizontal(.singleLine), title: "Layout: horizontal(.singleLine)"),
                self.makeGroup(layoutType: .horizontal(.autoGrow), title: "Layout: horizontal(.autoGrow)"),
                self.makeGroup(layoutType: .vertical(.singleLine), title: "Layout: vertical(.singleLine)"),
                self.makeGroup(layoutType: .vertical(.autoGrow), title: "Layout: vertical(.autoGrow)")
            ],
            isSearchable: true
        )
        return pane
    }

    private static func makeGroup(
        layoutType: StringItem.LayoutType,
        title: String
    ) -> ItemGroup {
        let stringItems = ItemGroup(
            title: .computed({ title }),
            items: .static([
                StringItem(
                    title: .static("Title (short)"),
                    value: .static("Value")
                ),
                StringItem(
                    title: .static("Title (short)"),
                    value: .static("Value"),
                    footerText: .static("A StringItem can be long pressed to share it's value")
                ),
                StringItem(
                    title: .static("Title (short)"),
                    value: .static("Value (medium length)"),
                    footerText: .static("A StringItem can be long pressed to share it's value")
                ),
                StringItem(
                    title: .static("Title (with a medium length)"),
                    value: .static("Value (medium length)"),
                    footerText: .static("A StringItem can be long pressed to share it's value")
                ),
                StringItem(
                    title: .static("Title (with a medium length)"),
                    value: .static("Value"),
                    footerText: .static("A StringItem can be long pressed to share it's value")
                ),
                StringItem(
                    title: .static("Title (with a medium length)"),
                    value: .static("Value (medium length)"),
                    footerText: .static("A StringItem can be long pressed to share it's value")
                ),
                StringItem(
                    title: .static("Title (with a very extensive and long length)"),
                    value: .static("Value (with a very extensive and long length)"),
                    footerText: .static("A StringItem can be long pressed to share it's value")
                )
            ].map({ stringItem in
                stringItem
                    .withLayoutType(.computed({ layoutType }))
                    .withTitleTextAttributes(.computed({ TitleAttributes.combined }))
                    .withValueTextAttributes(.computed({ ValueAttributes.combined }))
            }))
        )
        return stringItems
    }

    // swiftlint:disable:next function_body_length
    private static func makeTextAttributesGroup() -> ItemGroup {
        return ItemGroup(
            title: .static("Text Attributes"),
            items: .static([
                PickerGroup(
                    options: .static(TextAttributes.TextStyle.allCases.map { textStyle in
                        PickableStringItem(
                            identifier: .static(textStyle.rawValue),
                            title: .static("." + String(describing: textStyle)),
                            isSelected: .computed({
                                return Self.TitleAttributes.textStyle == textStyle
                            })
                        )
                    }),
                    onPickedOption: { item, result in
                        Self.TitleAttributes.textStyle = TextAttributes.TextStyle(rawValue: item.identifier.unboxed) ?? .body
                        self.pane.invalidate()
                        result(.success(shouldDismiss: true))
                    }
                )
                .asChildPaneItem(
                    title: .static("Title TextStyle"),
                    value: .computed({
                        return "." + String(describing: Self.TitleAttributes.textStyle)
                    })
                ),
                PickerGroup(
                    options: .static(TextAttributes.LineBreak.allCases.map { lineBreak in
                        PickableStringItem(
                            identifier: .static(lineBreak.rawValue),
                            title: .static("." + String(describing: lineBreak)),
                            isSelected: .computed({
                                return Self.TitleAttributes.lineBreak == lineBreak
                            })
                        )
                    }),
                    onPickedOption: { item, result in
                        Self.TitleAttributes.lineBreak = TextAttributes.LineBreak(rawValue: item.identifier.unboxed) ?? .wrapByWord
                        self.pane.invalidate()
                        result(.success(shouldDismiss: true))
                    }
                )
                .asChildPaneItem(
                    title: .static("Title LineBreak"),
                    value: .computed({
                        return "." + String(describing: Self.TitleAttributes.lineBreak)
                    })
                ),
                PickerGroup(
                    options: .static(TextAttributes.TextStyle.allCases.map { textStyle in
                        PickableStringItem(
                            identifier: .static(textStyle.rawValue),
                            title: .static("." + String(describing: textStyle)),
                            isSelected: .computed({
                                return Self.ValueAttributes.textStyle == textStyle
                            })
                        )
                    }),
                    onPickedOption: { item, result in
                        Self.ValueAttributes.textStyle = TextAttributes.TextStyle(rawValue: item.identifier.unboxed) ?? .body
                        self.pane.invalidate()
                        result(.success(shouldDismiss: true))
                    }
                )
                .asChildPaneItem(
                    title: .static("Value TextStyle"),
                    value: .computed({
                        return "." + String(describing: Self.ValueAttributes.textStyle)
                    })
                ),
                PickerGroup(
                    options: .static(TextAttributes.LineBreak.allCases.map { lineBreak in
                        PickableStringItem(
                            identifier: .static(lineBreak.rawValue),
                            title: .static("." + String(describing: lineBreak)),
                            isSelected: .computed({
                                return Self.ValueAttributes.lineBreak == lineBreak
                            })
                        )
                    }),
                    onPickedOption: { item, result in
                        Self.ValueAttributes.lineBreak = TextAttributes.LineBreak(rawValue: item.identifier.unboxed) ?? .wrapByWord
                        self.pane.invalidate()
                        result(.success(shouldDismiss: true))
                    }
                )
                .asChildPaneItem(
                    title: .static("Value LineBreak"),
                    value: .computed({
                        return "." + String(describing: Self.ValueAttributes.lineBreak)
                    })
                )
            ])
        )
    }
}
