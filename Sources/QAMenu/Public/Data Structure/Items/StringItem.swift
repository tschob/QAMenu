//
//  StringItem.swift
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

open class StringItem: Item, FooterSupport {

    // MARK: - Properties (Public)

    public enum LayoutType: Equatable {
        case horizontal(LineCount)
        case vertical(LineCount)

        public enum LineCount: Equatable {
            case singleLine
            case autoGrow
        }
    }

    public let title: Dynamic<String?>?
    public let value: Dynamic<String?>?
    public let footerText: Dynamic<String?>?
    public let layoutType: Dynamic<LayoutType>
    public let valueFallbackString: String

    override open var searchableContent: [String?] {
        return [
            self.title?(),
            self.value?(),
            self.footerText?()
        ]
    }

    // MARK: - Initialization

    public init(
        title: Dynamic<String?>?,
        value: Dynamic<String?>?,
        footerText: Dynamic<String?>? = nil,
        layoutType: Dynamic<LayoutType> = .static(.horizontal(.singleLine)),
        fallbackString: String = "<nil>"
    ) {
        self.title = title
        self.value = value
        self.footerText = footerText
        self.layoutType = layoutType
        self.valueFallbackString = fallbackString
    }
}

// MARK: - StringItem + Shareable

extension StringItem: Shareable {

    open var isSharingEnabled: Bool {
        guard let shareContent = self.shareContent, !shareContent.isEmpty else {
            return false
        }
        return true
    }

    open var shareContent: String? {
        return self.value?()
    }
}
