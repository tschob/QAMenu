//
//  ItemGroup.swift
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

open class ItemGroup: Group, Searchable {

    // MARK: - Properties

    open private(set) var title: Dynamic<String?>?
    open private(set) var items: [Item] {
        didSet {
            self.referenceGroup()
        }
    }
    open private(set) var footerText: Dynamic<String?>?

    open var searchableContent: [String?] {
        return [
            self.title?(),
            self.footerText?()
        ]
    }

    public let onInvalidation = InvalidationEvent()

    // MARK: - Initialization

    public init(
        title: Dynamic<String?>? = nil,
        items: [Item],
        footerText: Dynamic<String?>? = nil
    ) {
        self.title = title
        self.items = items
        self.footerText = footerText
        self.referenceGroup()
    }

    open func update(items: [Item]) {
        self.items = items
        self.invalidate()
    }

    private func referenceGroup() {
        self.items.forEach { $0.parentGroup = self }
    }

    // MARK: -

    public func removeTitle() {
        self.title = nil
    }
}
