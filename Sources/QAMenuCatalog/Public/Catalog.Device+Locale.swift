//
//  Catalog.Device+Locale.swift
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

public extension QAMenu.Catalog.Device {

    enum Locale {

        public static var all: [Group] {
            return [
                group()
            ]
        }

        public static func group(title: String = "Locale (Current)") -> ItemGroup {
            return ItemGroup(
                title: .computed({ title }),
                items: [
                    Items.identifierStringItem(),
                    Items.languageCodeStringItem(),
                    Items.regionCodeStringItem(),
                    Items.calendarStringItem(),
                    Items.currencyCodeStringItem(),
                    Items.preferredLanguagesStringItem()
                ]
            )
        }

        public enum Items {

            public static func identifierStringItem(title: String = "Identifier") -> StringItem {
                return StringItem(
                    title: .static(title),
                    value: .computed({ Foundation.Locale.current.identifier }),
                    layoutType: .static(.horizontal(.autoGrow))
                )
            }

            public static func languageCodeStringItem(title: String = "Language Code") -> StringItem {
                return StringItem(
                    title: .static(title),
                    value: .computed({ Foundation.Locale.current.languageCode }),
                    layoutType: .static(.horizontal(.autoGrow))
                )
            }

            public static func regionCodeStringItem(title: String = "Region Code") -> StringItem {
                return StringItem(
                    title: .static(title),
                    value: .computed({ Foundation.Locale.current.regionCode }),
                    layoutType: .static(.horizontal(.autoGrow))
                )
            }

            public static func calendarStringItem(title: String = "Calendar") -> StringItem {
                return StringItem(
                    title: .static(title),
                    value: .computed({ String(describing: Foundation.Locale.current.calendar) }),
                    layoutType: .static(.horizontal(.autoGrow))
                )
            }

            public static func currencyCodeStringItem(title: String = "Currency Code") -> StringItem {
                return StringItem(
                    title: .static(title),
                    value: .computed({ Foundation.Locale.current.currencyCode }),
                    layoutType: .static(.horizontal(.autoGrow))
                )
            }

            public static func preferredLanguagesStringItem(title: String = "Preferred Languages") -> StringItem {
                return StringItem(
                    title: .static(title),
                    value: .computed({ String(describing: Foundation.Locale.preferredLanguages) }),
                    layoutType: .static(.vertical(.autoGrow))
                )
            }
        }
    }
}
