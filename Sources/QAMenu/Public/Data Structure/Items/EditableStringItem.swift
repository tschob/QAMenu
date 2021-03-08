//
//  EditableStringItem.swift
//
//  Created by Hans Seiffert on 13.02.21.
//
//  ---
//  MIT License
//
//  Copyright © 2021 Hans Seiffert
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

open class EditableStringItem: StringItem {

    // MARK: - Properties (Public)

    public enum ValueChangeResult {
        case success
        case failure(String)
    }

    public let isEditable: Dynamic<Bool>
    public let onValueChange: ((_ newValue: String, _ item: EditableStringItem, _ result: @escaping (ValueChangeResult) -> Void) -> Void?)?

    public var onShouldEdit: ((_ item: EditableStringItem) -> Void)?

    // MARK: - Initialization

    public init(
        title: Dynamic<String?>?,
        value: Dynamic<String?>?,
        footerText: Dynamic<String?>? = nil,
        fallbackString: String = "",
        isEditable: Dynamic<Bool> = .static(true),
        onValueChange: @escaping (_ newValue: String, _ item: StringItem, _ result: @escaping (ValueChangeResult) -> Void) -> Void
    ) {
        self.isEditable = isEditable
        self.onValueChange = onValueChange
        super.init(
            title: title,
            value: value,
            footerText: footerText,
            fallbackString: fallbackString
        )
    }
}

// MARK: - EditableStringItem + Selectable

extension EditableStringItem: Selectable {

    open var isSelectable: Bool {
        return self.isEditable.unboxed
    }

    open var selectionOutcome: SelectionOutcome {
        return .custom { [weak self] in
            guard let self = self, self.isEditable.unboxed else {
                return
            }
            self.onShouldEdit?(self)
        }
    }
}
