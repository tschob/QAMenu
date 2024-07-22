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
import QAMenuUtils
import Combine

open class ItemGroup: Group, Searchable {

    // MARK: - Properties (Public)

    open private(set) var title: Dynamic<String?>?
    open private(set) var items: GroupItems
    open private(set) var footerText: Dynamic<String?>?

    open var searchableContent: [String?] {
        return [
            self.title?(),
            self.footerText?()
        ]
    }

    public let onInvalidation = InvalidationEvent()
    public private(set) lazy var  onInvalidationSubject = PassthroughSubject<Void, Never>()

    public let onPresentDialog = ObservableEvent<DialogContent>()
    public private(set) lazy var  onPresentDialogSubject = PassthroughSubject<DialogContent, Never>()

    // MARK: - Properties (Private / Internal)

    private var disposeBag = DisposeBag()

    // MARK: - Initialization

    public init(
        title: Dynamic<String?>? = nil,
        items: GroupItems,
        footerText: Dynamic<String?>? = nil
    ) {
        self.title = title
        self.items = items
        self.footerText = footerText

        self.observeItemsState()
        self.bindItems()
    }

    // MARK: - Methods (Public)

    open func update(
        items: GroupItems,
        loadDelayedContent: Bool = false
    ) {
        self.items = items
        self.observeItemsState()
        if loadDelayedContent {
            self.loadContent()
        }
    }

    public func removeTitle() {
        self.title = nil
    }

    public func loadContent() {
        items.load()
    }

    // MARK: - Methods (Private)

    private func reloadAfterDelayedStateChange() {
        self.bindItems()
        self.invalidate()
    }

    private func bindItems() {
        self.items.unboxed.forEach { $0.parentGroup = self }
    }

    private func observeItemsState() {
        self.items.state.observe({ [weak self] _ in
            self?.reloadAfterDelayedStateChange()
        })
        .disposeWith(self.disposeBag)
    }
}
