//
//  ShowcaseItemsFactory+DetailedItemExamples.swift
//
//  Created by Hans Seiffert on 11.07.20.
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
import QAMenuExampleItems

extension ShowcaseItemsFactory {

    struct CustomViews {

        struct ChildPane {
            static var advancedCustomScreen: ChildPaneItem {
                return ChildPaneItem(pane: {
                    CustomPane(
                        title: "Custom with Pane and nested navigation", childPane: {
                            self.customNestedScreenPane
                        }
                    )
                })
            }

            static var customStringView: CustomStringItem {
                return CustomStringItem(
                    title: .static("Your own"),
                    value: .static("custom view")
                )
            }

            static var simpleSwiftUIView: SimpleSwiftUIItem {
                return SimpleSwiftUIItem(
                    message: "Hello, World!",
                    response: "Hello,\nSwiftUI!"
                )
            }

            static var customScreen: ChildPaneItem {
                return ChildPaneItem(pane: {
                    CustomPane(
                        title: "Your own custom screen", childPane: {
                            self.customNestedScreenPane
                        }
                    )
                })
            }

            private static var customNestedScreenPane: Pane {
                return Pane(title: .static("QA Menu UI again"), groups: [
                    ItemGroup(items: .static([
                        StringItem(
                            title: .static("You are back in QA Menu UI"),
                            value: .static("👍")
                        )
                        .withLayoutType(.static(.horizontal(.singleLine)))
                    ]))
                ])
            }
        }
    }
}
