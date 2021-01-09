//
//  PickerGroup.swift
//
//  Created by Hans Seiffert on 29.11.20.
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

open class PickerGroup: Group, DialogTrigger, NavigationTrigger {

    public enum PickResult {
        case success(shouldDismiss: Bool)
        case failure(String)
    }

    // MARK: - Properties

    open private(set) var title: Dynamic<String?>?
    open var items: [Item] {
        return options
    }
    open private(set) var options: [PickableItem] {
        didSet {
            self.linkCurrentItems()
        }
    }
    open private(set) var footerText: Dynamic<String?>?
    open private(set) var onPickedOption: ((_ item: PickableItem, _ result: (PickResult) -> Void) -> Void?)?

    open var onPresentDialog = ObservableEvent<DialogContent>()

    open var onNavigateBack = ObservableEvent<(() -> Void)>()

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
        options: [PickableItem],
        footerText: Dynamic<String?>? = nil,
        onPickedOption: @escaping ((_ item: PickableItem, _ result: ((PickResult) -> Void)) -> Void)
    ) {
        self.title = title
        self.options = options
        self.footerText = footerText
        self.onPickedOption = onPickedOption

        self.linkCurrentItems()
    }

    // MARK: -

    open func update(options: [PickableItem]) {
        self.options = options
        self.invalidate()
    }

    private func linkCurrentItems() {
        // Reference the group as parent
        self.items.forEach { $0.parentGroup = self }
        // Observe the pick events
        self.addObserver(for: options)
    }

    private func addObserver(for options: [PickableItem]) {
        options.forEach { pickableItem in
            pickableItem.onPick = { [weak self] item in
                self?.onPickedOption?(item) { result in
                    self?.handlePickResult(result)
                }
            }
        }
    }

    // MARK: - Methods

    private func handlePickResult(_ result: PickResult) {
        switch result {
        case .success(let shouldDismiss):
            if shouldDismiss {
                self.onNavigateBack.fire(with: { [weak self] in
                    self?.invalidate()
                })
            } else {
                self.invalidate()
            }
        case .failure(let message):
            let dialogContent = DialogContent(title: "Error", message: message)
            self.onPresentDialog.fire(with: dialogContent)
        }
    }

    public func removeTitle() {
        self.title = nil
    }
}
