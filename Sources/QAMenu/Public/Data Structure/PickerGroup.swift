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
import QAMenuUtils

// MARK: - PickerGroup

open class PickerGroup: Group, DialogTrigger, NavigationTrigger {

    public enum PickResult {
        case success(shouldDismiss: Bool)
        case failure(String)
    }

    // MARK: - Properties (Public)

    open var items: GroupItems {
        let items = self.options.unboxedOptions ?? self.options.unboxedItems
        return .static(items)
    }

    open private(set) var title: Dynamic<String?>?
    open private(set) var options: PickerGroupOptions
    open private(set) var footerText: Dynamic<String?>?
    open private(set) var onPickedOption: ((_ item: PickableItem, _ result: @escaping (PickResult) -> Void) -> Void?)?

    open var onPresentDialog = ObservableEvent<DialogContent>()

    open var onNavigateBack = ObservableEvent<(() -> Void)>()

    open var searchableContent: [String?] {
        return [
            self.title?(),
            self.footerText?()
        ]
    }

    public let onInvalidation = InvalidationEvent()

    // MARK: - Properties (Private / Internal)

    private var disposeBag = DisposeBag()

    // MARK: - Initialization

    public init(
        title: Dynamic<String?>? = nil,
        options: PickerGroupOptions,
        footerText: Dynamic<String?>? = nil,
        onPickedOption: @escaping (_ item: PickableItem, _ result: @escaping ((PickResult) -> Void)) -> Void
    ) {
        self.title = title
        self.options = options
        self.footerText = footerText
        self.onPickedOption = onPickedOption

        self.observeOptionsState()
        self.bindOptions()
    }

    // MARK: - Methods (Public)

    open func update(
        options: PickerGroupOptions,
        loadDelayedContent: Bool = false
    ) {
        self.options = options
        self.observeOptionsState()
        if loadDelayedContent {
            self.loadContent()
        }
    }

    public func removeTitle() {
        self.title = nil
    }

    public func loadContent() {
        options.load()
    }

    // MARK: - Methods (Private)

    private func reloadAfterDelayedStateChange() {
        self.bindOptions()
        self.invalidate()
    }

    private func bindOptions() {
        // Reference the group as parent
        self.items.unboxed.forEach { $0.parentGroup = self }
        // Observe the pick events
        if let options = self.options.unboxedOptions {
            self.addObserver(for: options)
        }
    }

    private func observeOptionsState() {
        self.options.state.observe({ [weak self] _ in
            self?.reloadAfterDelayedStateChange()
        })
        .disposeWith(self.disposeBag)
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
}
