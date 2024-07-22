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
import Combine

open class Item: Invalidatable, DialogTrigger, Searchable {

    // MARK: - Properties (Public)

    open var searchableContent: [String?] {
        return []
    }

    public let onInvalidation = InvalidationEvent()
    public private(set) lazy var onInvalidationSubject = PassthroughSubject<Void, Never>()

    public let onPresentDialog = ObservableEvent<DialogContent>()
    public private(set) lazy var onPresentDialogSubject = PassthroughSubject<DialogContent, Never>()

    open weak var parentGroup: Group?

    // MARK: - Properties (Internal)

    open class var typeId: String {
        return String(describing: self)
    }

    public init() {}
}

// MARK: - Item + Conversions

extension Item {

    public func asItemGroup(
        title: Dynamic<String?>? = nil,
        footerText: Dynamic<String?>? = nil
    ) -> ItemGroup {
        return [self]
            .asItemGroup(
                title: title,
                footerText: footerText
            )
    }

    public func asPane(
        title: Dynamic<String?>,
        isReloadable: Bool = false,
        isSearchable: Bool = false
    ) -> Pane {
        return [self]
            .asItemGroup()
            .asPane(
                title: title,
                isReloadable: isReloadable,
                isSearchable: isSearchable
            )
    }

    public func asChildPaneItem(
        title: Dynamic<String?>,
        value: Dynamic<String?>? = nil,
        footerText: Dynamic<String?>? = nil,
        layoutType: Dynamic<StringItem.LayoutType> = .static(.horizontal(.singleLine)),
        fallbackString: String = "",
        isPaneReloadable: Bool = false,
        isPaneSearchable: Bool = false
    ) -> ChildPaneItem {
        return [self]
            .asPane(
                title: title,
                isReloadable: isPaneReloadable,
                isSearchable: isPaneSearchable
            )
            .asChildPaneItem(
                value: value,
                footerText: footerText,
                layoutType: layoutType,
                fallbackString: fallbackString
            )
    }
}

// MARK: - Array<Item> + Conversions

extension Array where Element: Item {

    public func asItemGroup(
        title: Dynamic<String?>? = nil,
        footerText: Dynamic<String?>? = nil
    ) -> ItemGroup {
        return ItemGroup(
            title: title,
            items: .static(self),
            footerText: footerText
        )
    }

    public func asPane(
        title: Dynamic<String?>,
        isReloadable: Bool = false,
        isSearchable: Bool = false
    ) -> Pane {
        return self
            .asItemGroup()
            .asPane(
                title: title,
                isReloadable: isReloadable,
                isSearchable: isSearchable
            )
    }

    public func asChildPaneItem(
        title: Dynamic<String?>,
        value: Dynamic<String?>? = nil,
        footerText: Dynamic<String?>? = nil,
        layoutType: Dynamic<StringItem.LayoutType> = .static(.horizontal(.singleLine)),
        fallbackString: String = "",
        isPaneReloadable: Bool = false,
        isPaneSearchable: Bool = false
    ) -> ChildPaneItem {
        return self
            .asPane(
                title: title,
                isReloadable: isPaneReloadable,
                isSearchable: isPaneSearchable
            )
            .asChildPaneItem(
                value: value,
                footerText: footerText,
                layoutType: layoutType,
                fallbackString: fallbackString
            )
    }
}
