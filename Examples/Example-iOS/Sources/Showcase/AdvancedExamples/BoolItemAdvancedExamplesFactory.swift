//
//  BoolItemAdvancedExamplesFactory.swift
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

import UIKit
import QAMenu

class BoolItemAdvancedExamplesFactory {

    struct Storage {
        static var bool_1_1 = true
        static var bool_1_2 = false
        static var bool_1_3 = true
        static var bool_1_4 = false

        static var bool_2_1 = false
    }

    func makePane() -> Pane {

        let group_1 = ItemGroup(items: .static([
            BoolItem(
                title: .static("Title (short)"),
                value: .computed({ Self.Storage.bool_1_1 }),
                onValueChange: { newValue, _, result in
                    Self.Storage.bool_1_1 = newValue
                    result(.success)
                }
            ),
            BoolItem(
                title: .static("Title (medium length)"),
                value: .computed({ Self.Storage.bool_1_2 }),
                footerText: .static("Using the switch will result in a failure for this item."),
                onValueChange: { _, _, result in
                    result(.failure("Wasn't able to toggle the boolean"))
                }
            ),
            BoolItem(
                title: .static("Title (with a very extensive and long length)"),
                value: .computed({ Self.Storage.bool_1_3 }),
                footerText: .computed({ Self.Storage.bool_1_3 ? "Using the switch will remove the footer text for this item." : "" }),
                onValueChange: { newValue, _, result in
                    Self.Storage.bool_1_3 = newValue
                    result(.success)
                }
            ),
            BoolItem(
                title: .computed({ Self.Storage.bool_1_4 ? "Title (short)" : "Title (with a very extensive and long length)" }),
                value: .computed({ Self.Storage.bool_1_4 }),
                footerText: .static("Using the switch will change the title for this item."),
                onValueChange: { newValue, _, result in
                    Self.Storage.bool_1_4 = newValue
                    result(.success)
                }
            )
        ]))

        let group2 = ShowcaseItemsFactory.DetailedItemExamples.Bool.DynamicGroup.group

        let pane = Pane(
            title: .static("BoolItem"),
            groups: [
                group_1,
                group2
            ]
        )
        return pane
    }
}
