//
//  EditableStringItemAdvancedExamplesFactory.swift
//
//  Created by Hans Seiffert on 13.02.21.
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

import QAMenu

// swiftlint:disable:next type_name
struct EditableStringItemAdvancedExamplesFactory {

    struct Storage {
        static var layoutExampleStringValues = [
            "Value",
            "Value",
            "Value (medium length)",
            "Value (medium length)",
            "Value",
            "Value (medium length)",
            "Value (with a very extensive and long length)"
        ]

        static var example1String = "value"
        static var example2String = "valid"
        static var example3String = "value"
    }

    static func makePane() -> Pane {
        let pane = Pane(
            title: .static("EditableStringItem"),
            groups: [
                self.makeEditExampleGroup(),
                self.makeLayoutExampleGroup(layoutType: .horizontal(.singleLine), title: "Layout: horizontal(.singleLine)"),
                self.makeLayoutExampleGroup(layoutType: .horizontal(.autoGrow), title: "Layout: horizontal(.autoGrow)"),
                self.makeLayoutExampleGroup(layoutType: .vertical(.singleLine), title: "Layout: vertical(.singleLine)"),
                self.makeLayoutExampleGroup(layoutType: .vertical(.autoGrow), title: "Layout: vertical(.autoGrow)")
            ],
            isSearchable: true
        )
        return pane
    }

    private static func makeEditExampleGroup() -> ItemGroup {
        return ItemGroup(items: .static([
            EditableStringItem(
                title: .static("Freestyle"),
                value: .computed({ Storage.example1String }),
                onValueChange: { newValue, _, result in
                    Storage.example1String = newValue
                    result(.success)
                }
            ),
            EditableStringItem(
                title: .static("Only valid"),
                value: .computed({ Storage.example2String }),
                footerText: .static("The value has to equal \"valid\""),
                onValueChange: { newValue, _, result in
                    if newValue == "valid" {
                        Storage.example2String = newValue
                        result(.success)
                    } else {
                        result(.failure("\"\(newValue)\" does not equal \"valid\""))
                    }
                }
            )
        ]))
    }

    // swiftlint:disable:next function_body_length
    private static func makeLayoutExampleGroup(layoutType: StringItem.LayoutType, title: String) -> ItemGroup {
        let stringItems = ItemGroup(
            title: .computed({ title }),
            items: .static([
                EditableStringItem(
                    title: .static("Title (short)"),
                    value: .computed({ Storage.layoutExampleStringValues[0] }),
                    onValueChange: { newValue, _, result in
                        Storage.layoutExampleStringValues[0] = newValue
                        result(.success)
                    }
                )
                .withLayoutType(.static(layoutType)),
                EditableStringItem(
                    title: .static("Title (short)"),
                    value: .computed({ Storage.layoutExampleStringValues[1] }),
                    footerText: .static("A StringItem can be long pressed to share it's value"),
                    onValueChange: { newValue, _, result in
                        Storage.layoutExampleStringValues[1] = newValue
                        result(.success)
                    }
                )
                .withLayoutType(.static(layoutType)),
                EditableStringItem(
                    title: .static("Title (short)"),
                    value: .computed({ Storage.layoutExampleStringValues[2] }),
                    footerText: .static("A StringItem can be long pressed to share it's value"),
                    onValueChange: { newValue, _, result in
                        Storage.layoutExampleStringValues[2] = newValue
                        result(.success)
                    }
                )
                .withLayoutType(.static(layoutType)),
                EditableStringItem(
                    title: .static("Title (with a medium length)"),
                    value: .computed({ Storage.layoutExampleStringValues[3] }),
                    footerText: .static("A StringItem can be long pressed to share it's value"),
                    onValueChange: { newValue, _, result in
                        Storage.layoutExampleStringValues[3] = newValue
                        result(.success)
                    }
                )
                .withLayoutType(.static(layoutType)),
                EditableStringItem(
                    title: .static("Title (with a medium length)"),
                    value: .computed({ Storage.layoutExampleStringValues[4] }),
                    footerText: .static("A StringItem can be long pressed to share it's value"),
                    onValueChange: { newValue, _, result in
                        Storage.layoutExampleStringValues[4] = newValue
                        result(.success)
                    }
                )
                .withLayoutType(.static(layoutType)),
                EditableStringItem(
                    title: .static("Title (with a medium length)"),
                    value: .computed({ Storage.layoutExampleStringValues[5] }),
                    footerText: .static("A StringItem can be long pressed to share it's value"),
                    onValueChange: { newValue, _, result in
                        Storage.layoutExampleStringValues[5] = newValue
                        result(.success)
                    }
                )
                .withLayoutType(.static(layoutType)),
                EditableStringItem(
                    title: .static("Title (with a very extensive and long length)"),
                    value: .computed({ Storage.layoutExampleStringValues[6] }),
                    footerText: .static("A StringItem can be long pressed to share it's value"),
                    onValueChange: { newValue, _, result in
                        Storage.layoutExampleStringValues[6] = newValue
                        result(.success)
                    }
                )
                .withLayoutType(.static(layoutType))
            ])
        )
        return stringItems
    }
}
