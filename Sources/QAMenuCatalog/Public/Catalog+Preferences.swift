//
//  Catalog+Preferences.swift
//
//  Created by Hans Seiffert on 18.07.20.
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

public extension QAMenu.Catalog {

    enum Preferences {

        public static var all: [Group] {
            return [
                group()
            ]
        }

        public static func group(
            title: Dynamic<String?> = .static("Preferences")
        ) -> ItemGroup {
            let userDefaultsChildPaneItem = Items.standardUserDefaultsChildPaneItem()
            let customPreferencesItems = Items.customPreferencesPListsChildPaneItems()

            let items: [ChildPaneItem] = [userDefaultsChildPaneItem] + customPreferencesItems
            return ItemGroup(
                title: title,
                items: items
            )
        }

        public enum Items {

            public static func standardUserDefaultsChildPaneItem(
                title: Dynamic<String?> = .static("Standard User Defaults")
            ) -> ChildPaneItem {
                let stringItems = Foundation.UserDefaults.standard.dictionaryRepresentation().dm_toStringItems()
                let pane = Pane(
                    title: title,
                    groups: [ItemGroup(items: stringItems)],
                    isSearchable: true
                )
                return ChildPaneItem(pane: { pane })
            }

            public static func customPreferencesPListsChildPaneItems() -> [ChildPaneItem] {
                let customPreferenceItems: [ChildPaneItem] = self.customPreferencesPlistsNames.compactMap {
                    let title = $0.0
                    let group = ItemGroup(items: $0.1.dm_toStringItems())
                    let item = ChildPaneItem(
                        pane: { Pane(title: .static(title), groups: [group], isSearchable: true) }
                    )
                    return item
                }
                return customPreferenceItems
            }

            // swiftlint:disable line_length
            private static var customPreferencesPlistsNames: [(String, [String: Any])] {
                let fileManager = FileManager.default
                guard let libraryPath = fileManager.urls(for: .libraryDirectory, in: .userDomainMask).first?.appendingPathComponent("Preferences"),
                    let preferencesPath = try? fileManager.contentsOfDirectory(at: libraryPath, includingPropertiesForKeys: .none) else {
                    return [(String, [String: Any])]()
                }

                let combined: [(String, [String: Any])] = preferencesPath
                    .filter { $0.absoluteString.contains(".plist") }
                    .compactMap { (path: URL) in
                        let name = path.lastPathComponent.replacingOccurrences(of: ".plist", with: "")
                        guard name != Bundle.main.bundleIdentifier else {
                            return nil
                        }
                        var format = PropertyListSerialization.PropertyListFormat.xml
                        guard let data = try? Data(contentsOf: path),
                            let deserialized = try? PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: &format),
                            let dictionary = deserialized as? [String: Any] else {
                                return nil
                        }
                        return (name, dictionary)
                    }

                return combined
            }
        }
        // swiftlint:enable line_length
    }
}
