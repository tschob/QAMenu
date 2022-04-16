//
//  ShowcaseItemsFactory+CapabilitiesExamples.swift
//
//  Created by Hans Seiffert on 12.02.22.
//
//  ---
//  MIT License
//
//  Copyright © 2022 Hans Seiffert
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

public extension ShowcaseItemsFactory {

    struct CapabilitiesExamples {

        public static var group: ItemGroup {
            return ItemGroup(
                title: .static("Capabilities Examples"),
                items: .static([
                    DialogTriggers.pane.asChildPaneItem()
                ])
            )
        }

        public struct DialogTriggers {

            public static var pane: Pane {
                return Pane(title: .static("DialogTrigger"), groups: [
                    self.makeAdvancedDialogGroup(),
                    self.wrapItemInGroup(self.boolItem),
                    self.wrapItemInGroup(self.buttonItem),
                    self.wrapItemInGroup(self.progressItem),
                    self.wrapItemInGroup(self.childPaneItem),
                    self.wrapItemInGroup(self.editableStringItem),
                    self.pickerChildPaneItemGroup,
                    self.wrapItemInGroup(self.stringItemGroup)
                ])
            }

            private static func makeAdvancedDialogGroup() -> Group {
                let titleDialogButton = ButtonItem(title: .static("Trigger dialog without a message"), action: { item in
                    let dialogContent = DialogContent(
                        title: "This dialog contains only a title"
                    )
                    item.presentDialog(dialogContent)
                })
                let messageDialogButton = ButtonItem(title: .static("Trigger dialog without a title"), action: { item in
                    let dialogContent = DialogContent(
                        message: "This dialog contains only a message"
                    )
                    item.presentDialog(dialogContent)
                })
                let multipleActionsDialogButton = ButtonItem(title: .static("Trigger dialog with multiple actions"), action: { item in
                    let dialogContent = DialogContent(
                        title: "Advanced Dialog",
                        message: "This dialog contains multiple Actions",
                        primaryAction: DialogContent.Action(title: "Primary", buttonType: .destructive),
                        secondaryAction: DialogContent.Action(title: "Secondary", buttonType: .normal)
                    )
                    item.presentDialog(dialogContent)
                })
                return ItemGroup(title: .static("Advanced Dialogs"), items: .static([
                    titleDialogButton,
                    messageDialogButton,
                    multipleActionsDialogButton
                ]))
            }

            private static func makeDialogContent(withSource sourceName: String) -> DialogContent {
                return DialogContent(
                    title: "Dialog",
                    message: "This dialog was triggered using the \(sourceName) instance.",
                    closeButtonTitle: "Great"
                )
            }

            private static func makeDialogTriggerButton(withSource source: DialogTrigger, title: String) -> ButtonItem {
                return ButtonItem(
                    title: .static(title),
                    action: { _ in
                        source.presentDialog(self.makeDialogContent(withSource: "\(source.self)"))
                    }
                )
            }

            private static func wrapItemInGroup(_ item: Item, dialogTitle: String = "Trigger dialog") -> ItemGroup {
                return ItemGroup(
                    title: .static("\(item.self)"),
                    items: .static([item, self.makeDialogTriggerButton(withSource: item, title: dialogTitle)])
                )
            }

            private static var boolItem: BoolItem {
                return BoolItem(
                    title: .static("BoolItem"),
                    value: .static(true),
                    onValueChange: { _, _, result in
                        result(.success)
                    }
                )
            }

            private static var buttonItem: ButtonItem {
                return ButtonItem(
                    title: .static("ButtonItem"),
                    action: { _ in
                        // Nothing
                    }
                )
            }

            private static var progressItem: ProgressItem {
                return ProgressItem(state: .progress("ProgressItem"))
            }

            private static var childPaneItem: ChildPaneItem {
                return ChildPaneItem(pane: { Pane(title: .static("ChildPaneItem"), items: []) })
            }

            public static var editableStringValue = "Value"
            private static var editableStringItem: EditableStringItem {
                return EditableStringItem(
                    title: .static(""),
                    value: .computed({
                        editableStringValue
                    }),
                    onValueChange: { newValue, _, result in
                        editableStringValue = newValue
                        result(.success)
                    }
                )
            }

            public static var isPickableItemSelected = true
            private static var pickerChildPaneItemGroup: ItemGroup {
                let item = PickableStringItem(
                    identifier: .static("a"),
                    title: .static("PickableStringItem"),
                    isSelected: .computed({
                        return isPickableItemSelected
                    })
                )
                let pickerGroup = PickerGroup(
                    title: .static("PickerGroup"),
                    options: .init([item]),
                    onPickedOption: { _, result in
                        self.isPickableItemSelected.toggle()
                        result(.success(shouldDismiss: false))
                    }
                )
                let groups: [Group] = [
                    pickerGroup,
                    ItemGroup(
                        title: .static("\(item.self)"),
                        items: .static([
                            self.makeDialogTriggerButton(withSource: item, title: "Trigger dialog on PicableStringItem"),
                            self.makeDialogTriggerButton(withSource: pickerGroup, title: "Trigger dialog on PickerGroup")
                        ])
                    )
                ]
                return ChildPaneItem(
                    pane: {
                        return Pane(
                            title: .static("Picker"),
                            groups: groups
                        )
                    },
                    footerText: .static("PickerGroup, PickableStringItem")
                ).asItemGroup(title: .static("Picker"))
            }

            private static var stringItemGroup: StringItem {
                return StringItem(title: .static("StringItem"), value: nil)
            }
        }
    }
}
