//
//  ContainerTableViewCell.swift
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

internal final class ContainerTableViewCell: UITableViewCell {

    // MARK: - Properties (Internal)

    internal var stackView: UIStackView?
    internal var containedView: ItemUIRepresentable?

    internal var disclousureIndicatorView: DisclosureIndicatorView?

    // MARK: - Properties (Private)

    private static let minHeight = CGFloat(44)

    // MARK: - Lifecycle

    override internal init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.setupStackView()
        self.insertDisclosureIndicatorView()
    }

    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override internal func prepareForReuse() {
        self.containedView?.prepareForReuse()
    }

    // MARK: -

    internal func insertViewIfNeeded(_ view: ItemUIRepresentable & UIView) {
        guard self.containedView == nil else {
            return
        }
        self.containedView = view
        view.translatesAutoresizingMaskIntoConstraints = false

        self.stackView?.insertArrangedSubview(view, at: 0)
    }

    internal func setupStackView() {
        guard self.stackView == nil else {
            return
        }
        let _stackView = UIStackView()
        _stackView.distribution = .fill
        _stackView.alignment = .center

        self.stackView = _stackView
        // Insert the view
        self.contentView.addSubview(_stackView)
        // Add layout constraints
        _stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.contentView.layoutMarginsGuide.topAnchor.constraint(equalTo: _stackView.topAnchor),
            self.contentView.layoutMarginsGuide.bottomAnchor.constraint(equalTo: _stackView.bottomAnchor),
            self.contentView.layoutMarginsGuide.leadingAnchor.constraint(equalTo: _stackView.leadingAnchor),
            self.contentView.layoutMarginsGuide.trailingAnchor.constraint(equalTo: _stackView.trailingAnchor),
            self.contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: Self.minHeight)
        ])
    }

    internal func insertDisclosureIndicatorView() {
        let _view = DisclosureIndicatorView()
        _view.isHidden = true
        self.disclousureIndicatorView = _view

        self.stackView?.addArrangedSubview(_view)

        NSLayoutConstraint.activate([
            _view.widthAnchor.constraint(equalToConstant: 12),
            _view.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
}
