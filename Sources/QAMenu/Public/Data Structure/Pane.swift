//
//  Item.swift
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

import Foundation

open class Pane: NSObject, Invalidatable {

    // MARK: - Properties (Public)

    public class var typeId: String {
        return String(describing: self)
    }

    public let title: Dynamic<String?>
    public let groups: [Group]
    public let isSearchable: Bool

    open var onInvalidation = InvalidationEvent()

    // MARK: - Initialization

    public convenience init(
        title: Dynamic<String?>,
        items: [Item],
        isSearchable: Bool = false
    ) {
        self.init(
            title: title,
            groups: [ItemGroup(items: items)],
            isSearchable: isSearchable
        )
    }

    public init(
        title: Dynamic<String?>,
        groups: [Group],
        isSearchable: Bool = false
    ) {
        self.title = title
        self.groups = groups
        self.isSearchable = isSearchable
        super.init()
    }

    public func invalidate() {
        self.groups.forEach { $0.invalidate() }
        self.onInvalidation.fire()
    }
}

// MARK: - Pane + ChildPaneItem

extension Pane {

    open func asChildPaneItem(
        value: Dynamic<String?>? = nil,
        footerText: Dynamic<String?>? = nil,
        layoutType: Dynamic<StringItem.LayoutType> = .static(.horizontal(.singleLine)),
        fallbackString: String = ""
    ) -> ChildPaneItem {
        return ChildPaneItem(
            pane: { self },
            value: value,
            footerText: footerText,
            layoutType: layoutType,
            fallbackString: fallbackString
        )
    }
}

// MARK: - Array<Pane> + Conversions

extension Array where Element: Pane {

    public func asChildPaneItems(
        footerText: Dynamic<String?>? = nil
    ) -> [ChildPaneItem] {
        return self.map {
            $0.asChildPaneItem(
                footerText: footerText
            )
        }
    }
}
