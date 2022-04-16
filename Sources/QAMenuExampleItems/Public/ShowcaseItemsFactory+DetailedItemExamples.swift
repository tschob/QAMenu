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

public extension ShowcaseItemsFactory {

    // swiftlint:disable:next type_body_length
    struct DetailedItemExamples {

        public struct String {

            private static var timer: DispatchSourceTimer?

            public struct UpdatingTime {

                public  static var item: StringItem = {
                    let timeString: () -> Swift.String = {
                        return DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .long)
                    }
                    let stringItem = StringItem(title: .static("Time"), value: .computed(timeString))
                    if timer == nil {
                        timer = DispatchSource.makeTimerSource(flags: .strict, queue: .global())
                        timer?.schedule(deadline: .now(), repeating: .seconds(1))
                        timer?.setEventHandler {
                            DispatchQueue.main.async {
                                Self.update()
                            }
                        }
                        timer?.resume()
                    }
                    return stringItem
                }()

                private static func update() {
                    self.item.invalidate()
                }
            }
        }

        public struct ChildPane {

            public static var nestedChildren: ChildPaneItem {
                return ChildPaneItem(pane: {
                    Pane(title: .static("Inception 🔁 Go one level deeper"), groups: [
                        ItemGroup(items: .static([
                            ChildPaneItem(pane: { Pane(title: .static("Inception 🔁 Go another level deeper"), groups: [
                                ItemGroup(items: .static([
                                    StringItem(
                                        title: .static("End?"),
                                        value: .static("In theory you can do this forever")
                                    )
                                    .withLayoutType(.static(.horizontal(.singleLine)))
                                ]))
                            ])})
                        ]))
                    ])
                })
            }
        }

        public struct PickableString {

            internal struct Storage {
                internal static var onlyOneSelection: Swift.String = "1"
                internal static var singleSelection: Swift.String?
                internal static var multiSelection = [Swift.String]()
                internal static var layoutExamplesSelection = [Swift.String]()

                internal static let selectionExamplesOptions: [Swift.String: Swift.String] = [
                    "1": "Alpha",
                    "2": "Beta (invalid)",
                    "3": "Production"
                ]
            }

            public static var onlyOneSelectionItems: [PickableStringItem] {
                return self.Storage.selectionExamplesOptions.sorted(by: { $0.key < $1.key }).map { (key, value) in
                    PickableStringItem(
                        identifier: .static(key),
                        title: .static(value),
                        isSelected: .computed({
                            return self.Storage.onlyOneSelection == key
                        })
                    )
                }
            }

            public static var singleSelectionItems: [PickableStringItem] {
                return self.Storage.selectionExamplesOptions.sorted(by: { $0.key < $1.key }).map { (key, value) in
                    PickableStringItem(
                        identifier: .static(key),
                        title: .static(value),
                        isSelected: .computed({
                            return self.Storage.singleSelection == key
                        })
                    )
                }
            }

            public static var multiSelectionItems: [PickableStringItem] {
                return self.Storage.selectionExamplesOptions.sorted(by: { $0.key < $1.key }).map { (key, value) in
                    PickableStringItem(
                        identifier: .static(key),
                        title: .static(value),
                        isSelected: .computed({
                            return self.Storage.multiSelection.contains(key)
                        })
                    )
                }
            }

            public static var layoutExampleItems: [PickableStringItem] {
                return [
                    PickableStringItem(
                        identifier: .static("1"),
                        title: .static("Title (short)"),
                        isSelected: .computed({ self.Storage.layoutExamplesSelection.contains("1") })
                    ),
                    PickableStringItem(
                        identifier: .static("2"),
                        title: .static("Title (short)"),
                        value: .static("With a value text"),
                        isSelected: .computed({ self.Storage.layoutExamplesSelection.contains("2") })
                    ),
                    PickableStringItem(
                        identifier: .static("3"),
                        title: .static("Title (with a medium length)"),
                        isSelected: .computed({ self.Storage.layoutExamplesSelection.contains("3") })
                    ),
                    PickableStringItem(
                        identifier: .static("4"),
                        title: .static("Title (with a medium length)"),
                        value: .static("With a very extensive and long value text"),
                        footerText: .static("And footer text."),
                        isSelected: .computed({ self.Storage.layoutExamplesSelection.contains("4") })
                    )
                    .withValueTextAttributes(.static(TextAttributes(textStyle: .subheadline, lineBreak: .wrapByCharacter))),
                    PickableStringItem(
                        identifier: .static("5"),
                        title: .static("Title (with a very extensive and long length)"),
                        footerText: .static("With a long and multiline footer text."),
                        isSelected: .computed({ self.Storage.layoutExamplesSelection.contains("5") })
                    ),
                    PickableStringItem(
                        identifier: .static("6"),
                        title: .static("Title (with a very extensive and long length)"),
                        footerText: .static("This examples uses character wrapping instead of word line wrapping for the title."),
                        isSelected: .computed({ self.Storage.layoutExamplesSelection.contains("6") })
                    )
                    .withTitleTextAttributes(.static(TextAttributes(textStyle: .subheadline, lineBreak: .wrapByCharacter)))
                ]
            }
        }

        public struct PickerGroups {

            public static func onlyOneSelection(
                title: Swift.String? = "Only one selection",
                shouldDismiss: Swift.Bool = false
            ) -> PickerGroup {
                let group = PickerGroup(
                    title: .static(title),
                    options: .static(PickableString.onlyOneSelectionItems),
                    footerText: .static("Exactly one item can be selected. It's not possible to deselect all items."),
                    onPickedOption: { (item: PickableItem, result: ((PickerGroup.PickResult) -> Void)) in
                        guard let item = item as? PickableStringItem else {
                            return
                        }
                        switch item.identifier() {
                        case "1",
                             "3":
                            PickableString.Storage.onlyOneSelection = item.identifier()
                            result(.success(shouldDismiss: shouldDismiss))
                        case "2":
                            result(.failure("This option is currently not available"))
                        default:
                            result(.failure("Unknown option selected"))
                        }
                    }
                )
                return group
            }

            public static func singleSelection(
                title: Swift.String? = "Single selection",
                shouldDismiss: Swift.Bool = false
            ) -> PickerGroup {
                let group = PickerGroup(
                    title: .static(title),
                    options: .static(PickableString.singleSelectionItems),
                    footerText: .static("Only up to one item can be selected. It's possible to deselect all items."),
                    onPickedOption: { (item: PickableItem, result: ((PickerGroup.PickResult) -> Void)) in
                        guard let item = item as? PickableStringItem else {
                            return
                        }
                        switch item.identifier() {
                        case "1",
                             "3":
                            if item.isSelected() {
                                PickableString.Storage.singleSelection = nil
                            } else {
                                PickableString.Storage.singleSelection = item.identifier()
                            }
                            result(.success(shouldDismiss: shouldDismiss))
                        case "2":
                            result(.failure("This option is currently not available"))
                        default:
                            result(.failure("Unknown option selected"))
                        }
                    }
                )
                return group
            }

            public static func multiSelection(
                title: Swift.String? = "Multiple selections",
                shouldDismiss: Swift.Bool = false
            ) -> PickerGroup {
                let group = PickerGroup(
                    title: .static(title),
                    options: .static(PickableString.multiSelectionItems),
                    footerText: .static("Multiple items can be picked. It's possible to deselect all items."),
                    onPickedOption: { (item: PickableItem, result: ((PickerGroup.PickResult) -> Void)) in
                        guard let item = item as? PickableStringItem else {
                            return
                        }
                        switch item.identifier() {
                        case "1",
                             "3":
                            if item.isSelected() || PickableString.Storage.multiSelection.contains(item.identifier()) {
                                PickableString.Storage.multiSelection.removeAll(where: { $0 == item.identifier() })
                            } else {
                                PickableString.Storage.multiSelection.append(item.identifier())
                            }
                            result(.success(shouldDismiss: shouldDismiss))
                        case "2":
                            result(.failure("This option is currently not available"))
                        default:
                            result(.failure("Unknown option selected"))
                        }
                    }
                )
                return group
            }

            public static func layoutExamples(
                title: Swift.String? = "Layout Examples",
                shouldDismiss: Swift.Bool = false
            ) -> PickerGroup {
                let group = PickerGroup(
                    title: .static(title),
                    options: .static(PickableString.layoutExampleItems),
                    footerText: .static("Showcases the different layout and string length combinations"),
                    onPickedOption: { (item: PickableItem, result: ((PickerGroup.PickResult) -> Void)) in
                        guard let item = item as? PickableStringItem else {
                            return
                        }
                        if item.isSelected() {
                            PickableString.Storage.layoutExamplesSelection.removeAll(where: { $0 == item.identifier() })
                        } else {
                            PickableString.Storage.layoutExamplesSelection.append(item.identifier())
                        }
                        result(.success(shouldDismiss: shouldDismiss))
                    }
                )
                return group
            }

            private static var remainingFailingLoadingCounts = [Swift.String: Int]()

            public static func delayedOptions(
                identifier: Swift.String,
                succeedsAfter: Int,
                allowRetry: Swift.Bool,
                shouldDismiss: Swift.Bool = false,
                footer: Swift.String
            ) -> PickerGroup {
                remainingFailingLoadingCounts[identifier] = succeedsAfter
                let group = PickerGroup(
                    title: .static("Delayed Options \(identifier)"),
                    options: .async({ instance in
                        instance.updateProgress(ProgressItem(state: .progress("Loading Part I")))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                            instance.updateProgress(ProgressItem(state: .progress("Loading Part II")))
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                                let remainingFailingLoadingCount = remainingFailingLoadingCounts[identifier] ?? 0
                                if remainingFailingLoadingCount <= 0 {
                                    instance.complete(PickableString.multiSelectionItems)
                                } else {
                                    let message = "Error: Loading fails the first \(remainingFailingLoadingCount) time(s)"
                                    instance.fail(
                                        ProgressItem(state: .failure(message)),
                                        onFailureOption: ButtonItem(
                                            title: .static("Try Again"),
                                            action: { (_, _) in
                                                instance.load()
                                            }
                                        )
                                    )
                                }
                                remainingFailingLoadingCounts[identifier] = remainingFailingLoadingCount - 1
                            })
                        })
                    }),
                    footerText: .static(footer),
                    onPickedOption: { (item: PickableItem, result: ((PickerGroup.PickResult) -> Void)) in
                        guard let item = item as? PickableStringItem else {
                            return
                        }
                        if item.isSelected() || PickableString.Storage.multiSelection.contains(item.identifier()) {
                            PickableString.Storage.multiSelection.removeAll(where: { $0 == item.identifier() })
                        } else {
                            PickableString.Storage.multiSelection.append(item.identifier())
                        }
                        result(.success(shouldDismiss: shouldDismiss))
                    }
                )
                return group
            }
        }
    }
}
