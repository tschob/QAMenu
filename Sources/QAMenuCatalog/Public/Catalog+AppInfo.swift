//
//  Catalog+AppInfo.swift
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

    enum AppInfo {

        public static var all: [Group] {
            return [
                group()
            ]
        }

        public static func group(title: Dynamic<String?> = .static("App Info")) -> ItemGroup {
            return [
                Items.appVersionStringItem(),
                Items.appBuildNumberStringItem(),
                Items.infoPlistChildPaneItem()
            ].compactMap({ $0 }).asItemGroup(title: title)
        }

        public enum Items {

            public static func appVersionStringItem(title: Dynamic<String?> = .static("Marketing Version")) -> StringItem {
                return StringItem(title: title, value: .computed({
                    guard let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
                        return "-"
                    }
                    return version
                }))
            }

            public static func appBuildNumberStringItem(title: Dynamic<String?> = .static("Build Number")) -> StringItem {
                return StringItem(title: title, value: .computed({
                    guard let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String else {
                        return "-"
                    }
                    return version
                }))
            }

            public static func infoPlistChildPaneItem(title: Dynamic<String?> = .static("Info Plist")) -> ChildPaneItem? {
                guard let stringItems = Bundle.main.infoDictionary?.dm_toStringItems() else {
                    return nil
                }
                return stringItems.asChildPaneItem(title: title, isPaneSearchable: true)
            }
        }
    }
}
