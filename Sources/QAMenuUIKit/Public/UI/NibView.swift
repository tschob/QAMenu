//
//  NibView.swift
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

open class NibView: UIView {

    // MARK: - Properties (Private)

    public static var nibName: String {
        return String(describing: Self.self)
    }

    open var nib: UINib {
        return UINib(nibName: Self.nibName, bundle: Bundle.dm_resources)
    }

    // MARK: - Initialization

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.initFromNib()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initFromNib()
    }

    // MARK: - 

    open func initFromNib() {
        guard let view = self.nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
                view.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
                view.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: self.topAnchor),
                view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
        }
    }
}
