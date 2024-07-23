//
//  ButtonItemView.swift
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
import Combine
import UIKit
import QAMenu
import QAMenuUtils

internal final class ButtonItemView: NibView, ItemView {

    // MARK: - Properties (Internal)

    internal weak var delegate: ItemUIRepresentableDelegate?

    internal var footerText: Dynamic<String?>? {
        return item?.footerText
    }

    internal var footerContainer: UIStackView {
        return self.stackView
    }

    // MARK: - Properties (Private)

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var progressLabel: UILabel!
    @IBOutlet private weak var indicator: UIActivityIndicatorView!
    @IBOutlet private weak var progressContainerView: UIView!
    @IBOutlet private weak var stackView: UIStackView!

    private var subscription: AnyCancellable?

    private weak var item: ButtonItem? {
        didSet {
            self.subscription?.cancel()
            self.subscription = self.item?.onInvalidationSubject
                .sink(receiveValue: { [weak self] in
                    self?.reload()
                })
            self.updateViewContent()
        }
    }

    // MARK: - Lifecycle

    override internal func initFromNib() {
        super.initFromNib()
        self.applyStyle()
        self.setupFooterView()
    }

    internal func prepareForReuse() {
        self.item = nil
    }

    internal func setItem(_ item: Item) {
        guard let buttonItem = item as? ButtonItem else {
            Logger.error("\(Self.self) expected to receive a ButtonItem, but \(item) was passed")
            return
        }

        self.item = buttonItem
    }

    // MARK: - Methods (Private)

    private func updateViewContent() {
        self.updateProgressViews(for: item?.status)
        self.updateFooterView()
    }

    private func applyStyle() {
        self.progressLabel.numberOfLines = 0
        self.progressLabel.textColor = .systemGray
        self.progressLabel.font = .preferredFont(forTextStyle: .body)
        self.titleLabel.numberOfLines = 0
        self.titleLabel.textColor = .link
        self.titleLabel.font = .preferredFont(forTextStyle: .body)
        self.indicator.style = .medium
    }

    private func reload() {
        self.updateViewContent()
        self.delegate?.updateContainerHeight(for: self)
    }

    private func updateProgressViews(for status: ButtonItem.ActionStatus?) {
        let status = status ?? .idle
        switch status {
        case .idle:
            self.titleLabel.text = item?.title()
            self.progressLabel.text = nil
            self.progressContainerView.isHidden = true
            self.indicator.stopAnimating()
            self.titleLabel.isHidden = false
        case .progress(let message):
            self.titleLabel.text = nil
            self.progressLabel.text = message
            self.progressContainerView.isHidden = false
            self.indicator.startAnimating()
            self.titleLabel.isHidden = true
        }
    }
}
