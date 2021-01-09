//
//  QAMenuPresenterUI.swift
//
//  Created by Hans Seiffert on 30.05.20.
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
import QAMenuUtils

open class QAMenuPresenterUI {

    open private(set) var items = [String: ItemUIRepresentable.Type]()
    open private(set) var panes = [String: PaneUIKitRepresentable.Type]()

    public init() {}

    // MARK: - Panes

    open func register(_ representable: PaneUIKitRepresentable.Type, for pane: Pane.Type) {
        self.panes[pane.typeId] = representable
    }

    open func retrieve(for pane: Pane.Type) -> PaneUIKitRepresentable.Type {
        guard let representable = self.panes[pane.typeId] else {
            Logger.error("No UI representation is registered for pane of type \(pane)")
            return UnsupportedPaneViewController.self
        }
        return representable
    }

    // MARK: - Items

    open func register(_ representable: ItemUIRepresentable.Type, for item: Item.Type) {
        self.items[item.typeId] = representable
    }

    open func retrieve(for item: Item.Type) -> ItemUIRepresentable.Type {
        guard let representable = self.items[item.typeId] else {
            Logger.error("No UI representation is registered for item of type \(item)")
            return UnsupportedItemView.self
        }
        return representable
    }
}
