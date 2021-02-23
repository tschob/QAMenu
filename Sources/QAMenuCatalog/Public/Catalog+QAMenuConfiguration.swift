//
//  Catalog+QAMenuConfigurationItem.swift
//
//  Created by Hans Seiffert on 30.01.21.
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
import QAMenu

public extension QAMenu.Catalog {

    enum QAMenuConfiguration {

        public static func all(
            qaMenu: QAMenu?
        ) -> [Group] {
            return [
                group(
                    qaMenu: qaMenu
                )
            ]
        }

        public static func group(
            title: String = "QAMenu Configuration",
            qaMenu: QAMenu?
        ) -> ItemGroup {
            let dismissBehaviorPicker = Items.dismissBehaviorPicker(
                qaMenu: qaMenu,
                shouldDismiss: true
            )
            .asChildPaneItem(
                value: .computed({ [weak qaMenu] in
                    qaMenu?.dismissBehavior.description
                }),
                layoutType: .static(.vertical(.autoGrow))
            )

            return ItemGroup(
                title: .static(title),
                items: .static([
                    Items.triggerBoolItem(qaMenu: qaMenu),
                    dismissBehaviorPicker
                ])
            )
        }

        public enum Items {

            public static func triggerBoolItem(qaMenu: QAMenu?) -> BoolItem {
                return BoolItem(
                    title: .static("Shake to open / close"),
                    value: .computed({ [weak qaMenu] in
                        qaMenu?.trigger.contains(.shake) ?? false
                    }),
                    onValueChange: { [weak qaMenu]  (newValue, _, result) in
                        guard let qaMenu = qaMenu else {
                            result(.failure("QAMenu instance doesn't exist anymore"))
                            return
                        }
                        if newValue {
                            var trigger = qaMenu.trigger
                            trigger.append(.shake)
                            qaMenu.setTrigger(trigger, mode: .forceReplace)
                        } else {
                            var trigger = qaMenu.trigger
                            trigger.removeAll(where: { $0 == .shake })
                            qaMenu.setTrigger(trigger, mode: .forceReplace)
                        }
                        result(.success)
                    }
                )
            }

            public static func dismissBehaviorPicker(
                qaMenu: QAMenu?,
                shouldDismiss: Bool
            ) -> PickerGroup {
                let options = [
                    QAMenu.DismissBehavior.resetImmediately.asPickableStringItem(qaMenu: qaMenu),
                    QAMenu.DismissBehavior.resetAfter(30).asPickableStringItem(qaMenu: qaMenu),
                    QAMenu.DismissBehavior.neverReset.asPickableStringItem(qaMenu: qaMenu)
                ]
                return PickerGroup(
                    title: .static("Close behavior"),
                    options: .static(options),
                    footerText: .static("A reset navigates back to the root pane."),
                    onPickedOption: { (item, result) in
                        switch item.identifier() {
                        case "\(QAMenu.DismissBehavior.resetImmediately)":
                            qaMenu?.setDismissBehavior(.resetImmediately, mode: .forceReplace)
                        case "\(QAMenu.DismissBehavior.resetAfter(30))":
                            qaMenu?.setDismissBehavior(.resetAfter(30), mode: .forceReplace)
                        case "\(QAMenu.DismissBehavior.neverReset)":
                            qaMenu?.setDismissBehavior(.neverReset, mode: .forceReplace)
                        default:
                            result(.failure("Couldn't map identifier to QAMenu.DismissBehavior"))
                            return
                        }
                        result(.success(shouldDismiss: shouldDismiss))
                    }
                )
            }
        }
    }
}

// MARK: - QAMenu.DismissBehavior + Catalog

private extension QAMenu.DismissBehavior {

    var description: String {
        switch self {
        case .resetImmediately:
            return "Reset Immediately"
        case .resetAfter:
            return "Reset after 30 seconds"
        case .neverReset:
            return "Never reset"
        }
    }

    func asPickableStringItem(qaMenu: QAMenu?) -> PickableStringItem {
        return PickableStringItem(
            identifier: .static("\(self)"),
            title: .static(self.description),
            isSelected: .computed({ [weak qaMenu] in
                return qaMenu?.dismissBehavior == self
            })
        )
    }
}
