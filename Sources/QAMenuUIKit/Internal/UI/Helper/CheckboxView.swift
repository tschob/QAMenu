//
//  CheckboxView.swift
//
//  Created by Hans Seiffert on 13.12.20.
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

internal final class CheckboxView: UIView {

    // MARK: - Properties (Internal)

    internal var color = UIColor.systemBlue

    // MARK: - Initialization

    override internal init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    internal required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
    }

    // MARK: - Methods

    override internal func draw(_ rect: CGRect) {
        let scale = self.bounds.width / 100
        let context = UIGraphicsGetCurrentContext()
        let centerX = self.bounds.midX
        let centerY = self.bounds.midY

        context?.move(to: CGPoint(x: centerX - 23 * scale, y: centerY + 4 * scale))
        context?.addLine(to: CGPoint(x: centerX - 6 * scale, y: centerY + 22 * scale))
        context?.addLine(to: CGPoint(x: centerX + 22 * scale, y: centerY - 22 * scale))

        context?.setLineCap(.round)
        context?.setLineJoin(.round)
        context?.setLineWidth(2)
        color.setStroke()
        context?.strokePath()
    }
}
