//
//  TextAttributes+UIKit.swift
//
//  Created by Hans Seiffert on 07.03.21.
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

import UIKit
import QAMenu

// MARK: - TextAttributes.TextStyle + UIFont.TextStyle

extension TextAttributes.TextStyle {

    internal var asUIFontTextStyle: UIFont.TextStyle {
        switch self {
        case .largeTitle:
            if #available(iOS 11.0, *) {
                return .largeTitle
            } else {
                return .title1
            }
        case .title1:
            return .title1
        case .title2:
            return .title2
        case .title3:
            return .title3
        case .headline:
            return .headline
        case .subheadline:
            return .subheadline
        case .body:
            return .body
        case .callout:
            return .callout
        case .footnote:
            return .footnote
        case .caption1:
            return .caption1
        case .caption2:
            return .caption2
        }
    }
}

// MARK: - TextAttributes.LineBreak + NSLineBreakMode

extension TextAttributes.LineBreak {

    internal var asNSLineBreakMode: NSLineBreakMode {
        switch self {
        case .wrapByCharacter:
            return .byCharWrapping
        case .wrapByWord:
            return .byWordWrapping
        }
    }
}
