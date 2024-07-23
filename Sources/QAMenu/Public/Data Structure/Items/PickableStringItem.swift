//
//  PickableStringItem.swift
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

open class PickableStringItem: PickableItem, FooterSupport {

    override public var toString: String? {
        return self.title.unboxed
    }

    override open var searchableContent: [String?] {
        return [
            self.toString,
            self.value?.unboxed,
            self.footerText?.unboxed
        ]
    }

    public let title: Dynamic<String>
    public let value: Dynamic<String?>?

    public private (set) var titleTextAttributes: Dynamic<TextAttributes> = .static(.init(textStyle: .body, lineBreak: .wrapByWord))
    public private (set) var valueTextAttributes: Dynamic<TextAttributes> = .static(.init(textStyle: .body, lineBreak: .wrapByWord))

    public let footerText: Dynamic<String?>?

    public init(
        identifier: Dynamic<String>,
        title: Dynamic<String>,
        value: Dynamic<String?>? = nil,
        footerText: Dynamic<String?>? = nil,
        isSelected: Dynamic<Bool>
    ) {
        self.title = title
        self.value = value
        self.footerText = footerText

        super.init(
            identifier: identifier,
            isSelected: isSelected
        )
    }

    // MARK: - Modifications

    @discardableResult
    public func withTitleTextAttributes(_ textAttributes: Dynamic<TextAttributes>) -> Self {
        self.titleTextAttributes = textAttributes
        return self
    }

    @discardableResult
    public func withValueTextAttributes(_ textAttributes: Dynamic<TextAttributes>) -> Self {
        self.valueTextAttributes = textAttributes
        return self
    }
}

// MARK: - PickableStringItem + Shareable

extension PickableStringItem: Shareable {

    public var isSharingEnabled: Bool {
        guard let shareContent = self.shareContent, !shareContent.isEmpty else {
            return false
        }
        return true
    }

    public var shareContent: String? {
        return self.value?() ?? self.title()
    }
}
