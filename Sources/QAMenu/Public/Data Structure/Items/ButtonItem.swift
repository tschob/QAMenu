//
//  ButtonItem.swift
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

open class ButtonItem: Item, FooterSupport {

    // MARK: - Properties (Public)

    public enum ActionStatus: Equatable {
        case idle
        case progress(String)
    }

    public let title: Dynamic<String>
    public let action: (_ item: ButtonItem) -> Void
    public let footerText: Dynamic<String?>?

    open var status: ActionStatus = .idle {
        didSet {
            self.invalidate()
        }
    }

    override open var searchableContent: [String?] {
        return [
            self.title(),
            self.footerText?()
        ]
    }

    // MARK: - Initialization

    public init(
        title: Dynamic<String>,
        action: @escaping (_ item: ButtonItem) -> Void,
        footerText: Dynamic<String?>? = nil
    ) {
        self.title = title
        self.action = action
        self.footerText = footerText
    }
}

// MARK: - ButtonItem + Selectable

extension ButtonItem: Selectable {

    public var isSelectable: Bool {
        guard case ActionStatus.idle = self.status else {
            return false
        }
        return true
    }

    public var selectionOutcome: SelectionOutcome {
        return .custom({ [weak self] in
            guard let self = self else {
                return
            }
            self.action(self)
        })
    }
}
