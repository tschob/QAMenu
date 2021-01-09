//
//  DisclosureIndicatorView.swift
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

internal final class DisclosureIndicatorView: UIView {

    // MARK: - Properties (Internal)

    internal var color = UIColor.systemGray

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
        let context = UIGraphicsGetCurrentContext()
        let xAxis = self.bounds.maxX
        let yAxis = self.bounds.midY
        let radius = CGFloat(5)
        let margin = CGFloat(3)
        context?.move(to: CGPoint(x: xAxis - radius - margin, y: yAxis - radius))
        context?.addLine(to: CGPoint(x: xAxis - margin, y: yAxis))
        context?.addLine(to: CGPoint(x: xAxis - radius - margin, y: yAxis + radius))
        context?.setLineCap(.round)
        context?.setLineJoin(.round)
        context?.setLineWidth(2)
        color.setStroke()
        context?.strokePath()
    }
}
