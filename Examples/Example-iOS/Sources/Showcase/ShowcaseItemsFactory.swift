//
//  ShowcaseItemsFactory.swift
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

// swiftlint:disable function_body_length
// swiftlint:disable line_length

import UIKit
import QAMenu
import QAMenuUIKit

class ShowcaseItemsFactory {

    class Storage {
        var storedBoolean = true
        var multilineStringTitle: String? = "Multiline String"
        var editableString: String? = "Value"
    }

    class func makeRootPane() -> RootPane {
        return RootPane(title: .static("QA Menu Showcase"), groups: self.makeGroups())
    }

    static var storage = Storage()

    private class func makeGroups() -> [Group] {
        let simpleCatalogGroup = ItemGroup(
            title: .static("Simple Catalog"),
            items: [
                EditableStringItem(
                    title: .static("Editable String"),
                    value: .computed({
                        self.storage.editableString
                    }),
                    layoutType: .static(.horizontal(.singleLine)),
                    isEditable: .static(true),
                    onValueChange: { newValue, _, result in
                        if newValue.count <= 2 {
                            result(.failure("You need to provide at least 3 character"))
                        } else {
                            self.storage.editableString = newValue
                            result(.success)
                        }
                    }
                ),
                StringItem(
                    title: .keyPath(\Storage.multilineStringTitle, for: ShowcaseItemsFactory.storage),
                    value: .static("Everything which is shown in the examples here is based on the (almost) UI-less data model structure 🚀"),
                    layoutType: .static(.vertical(.autoGrow))
                ),
                BoolItem(
                    title: .static("Editable boolean"),
                    value: .keyPath(\Storage.storedBoolean, for: ShowcaseItemsFactory.storage),
                    footerText: .computed({
                        var footer = "By the way: Every item can contain an optional footer text.💡"
                        if self.storage.storedBoolean {
                            footer = "Deselecting the switch will change this footer text." + "\n\n" + footer
                        } else {
                            footer = "Selecting the switch will change this footer text." + "\n\n" + footer
                        }
                        return footer
                    }),
                    onValueChange: { value, _, result in
                        self.storage.storedBoolean = value
                        result(.success)
                    }
                ),
                ChildPaneItem(
                    pane: { () -> Pane in
                        return ShowcaseItemsFactory.DetailedItemExamples.PickerGroups.onlyOneSelection(title: nil, shouldDismiss: true).asPane(title: .static("Picker"))
                    }, value: .computed({
                        let selected = ShowcaseItemsFactory.DetailedItemExamples.PickableString.Storage.onlyOneSelection
                        return ShowcaseItemsFactory.DetailedItemExamples.PickableString.Storage.options[selected]
                    })
                ),
                ButtonItem(
                    title: .static("Perform a task"),
                    action: { (item: ButtonItem, qaMenu: QAMenu) in
                        item.status = .progress("Performing long running task")
                        let alert = UIAlertController(
                            title: "You clicked the button!",
                            message: "This dialog simulates a long running task. Click the button below to complete it",
                            preferredStyle: .alert
                        )
                        let closeAction = UIAlertAction(
                            title: "Complete task",
                            style: .default,
                            handler: { [weak item] _ in
                                item?.status = .idle
                            }
                        )
                        alert.addAction(closeAction)
                        (qaMenu.presenter as? QAMenuUIKitPresenter)?.visiblePresentationContext?.present(alert, animated: true)
                    }
                ),
                DetailedItemExamples.ChildPane.nestedChildren,
                DetailedItemExamples.ChildPane.customScreen
            ],
            footerText: .static("Tip: Perform a long touch on a StringItem to share its value 💯")
        )

        let detailedCatalogGroup = ItemGroup(
            title: .static("Detailed item examples"),
            items: [
                ChildPaneItem(pane: { StringItemAdvancedExamplesFactory.makePane() }),
                ChildPaneItem(pane: { EditableStringItemAdvancedExamplesFactory.makePane() }),
                ChildPaneItem(pane: { BoolItemAdvancedExamplesFactory().makePane() }),
                ChildPaneItem(pane: { ButtonItemAdvancedExamplesFactory().makePane() }),
                ChildPaneItem(pane: {
                    Pane(title: .static("ChildPaneItem"), groups: [
                        ItemGroup(items: [
                            DetailedItemExamples.ChildPane.nestedChildren
                        ]),
                        ItemGroup(title: .static("Custom Panes"), items: [
                            DetailedItemExamples.ChildPane.simpleCustomScreen,
                            DetailedItemExamples.ChildPane.advancedCustomScreen
                        ])
                    ])
                }),
                ChildPaneItem(pane: { PickerGroupAdvancedExamplesFactory().makePane() })
            ]
        )

        let dynamicGroup = DetailedItemExamples.Bool.DynamicGroup.group
        let advancedExamples = ItemGroup(
            title: .static("Advanced examples"),
            items: [
                ChildPaneItem(pane: {
                    Pane(title: .computed({ "Dynamic Content" }), groups: [
                        dynamicGroup,
                        ItemGroup(items: [
                            DetailedItemExamples.String.UpdatingTime.item
                        ])
                    ])
                })
            ]
        )
        DetailedItemExamples.Bool.DynamicGroup.update(group: dynamicGroup)

        return [simpleCatalogGroup, detailedCatalogGroup, advancedExamples]
    }
}
