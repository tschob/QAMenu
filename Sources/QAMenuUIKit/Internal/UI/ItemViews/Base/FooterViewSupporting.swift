//
//  FooterViewSupporting.swift
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
import UIKit
import QAMenu

// MARK: - FooterViewSupporting

internal protocol FooterViewSupporting {

    var footerText: Dynamic<String?>? { get }
    var footerContainer: UIStackView { get }

    func setupFooterView()
    func updateFooterView()
}

// MARK: - FooterViewSupporting + Implementation

extension FooterViewSupporting {

    // MARK: - Properties (Private)

    private static var footerViewTag: Int { 1 }

    private var insertedFooterLabel: UILabel? {
        return self.footerContainer.viewWithTag(Self.footerViewTag) as? UILabel
    }

    // MARK: -

    internal func setupFooterView() {
        // Make sure the footer view is not added twice
        if let footerView = self.insertedFooterLabel {
            footerView.removeFromSuperview()
        }
        // Configure footer view
        let footerLabel = Self.makeFooterLabel()
        // Insert footer view
        self.footerContainer.addArrangedSubview(footerLabel)
    }

    internal func updateFooterView() {
        guard let footerLabel = self.insertedFooterLabel else {
            return
        }
        let text = self.footerText?()
        footerLabel.text = text
        footerLabel.sizeToFit()
        footerLabel.isHidden = (text == nil || text?.isEmpty == true)
    }

    private static func makeFooterLabel() -> UILabel {
        let label = UILabel()
        label.tag = self.footerViewTag
        label.numberOfLines = 0
        label.textColor = .darkGray
        label.font = .preferredFont(forTextStyle: .footnote)
        return label
    }
}
