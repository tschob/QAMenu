//
//  UnsupportedPaneViewController.swift
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

internal final class UnsupportedPaneViewController: UIViewController {

    // MARK: - Properties (Internal)

    internal var pane: Pane

    internal var qaMenu: QAMenu

    // MARK: - Properties (Private)

    private static let offset = CGFloat(10)

    // MARK: - Initialization

    internal init(pane: Pane, qaMenu: QAMenu) {
        self.pane = pane
        self.qaMenu = qaMenu
        super.init(nibName: nil, bundle: nil)
    }

    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLabel() {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
        label.text = "Error: No UI representation is registered for pane of type \(type(of: pane))"
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.numberOfLines = 0
        label.contentMode = .center
        label.textAlignment = .center
        self.view.addSubview(label)
        self.setupConstraints(label: label)
    }

    private func setupConstraints(label: UILabel) {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.view.topAnchor, constant: Self.offset),
            label.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -Self.offset),
            label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Self.offset * 2),
            label.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -Self.offset * 2)
        ])
    }

    // MARK: - Lifecycle

    override internal func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemGray
        self.title = "Error"
        setupLabel()
    }
}

// MARK: - UnsupportedPaneViewController + PaneUIKitRepresentable

extension UnsupportedPaneViewController: PaneUIKitRepresentable {

    internal func scrollToTop() {}

    internal static func make(for pane: Pane, in qaMenu: QAMenu) -> PaneUIKitRepresentable {
        return UnsupportedPaneViewController(pane: pane, qaMenu: qaMenu)
    }
}
