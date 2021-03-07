//
//  ProgressItemView.swift
//
//  Created by Hans Seiffert on 20.02.21.
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

import Foundation
import UIKit
import QAMenu
import QAMenuUtils

internal final class ProgressItemView: NibView, ItemView {

    // MARK: - Properties (Internal)

    internal weak var delegate: ItemUIRepresentableDelegate?

    internal var footerText: Dynamic<String?>? {
        return item?.footerText
    }

    internal var footerContainer: UIStackView {
        return self.stackView
    }

    // MARK: - Properties (Private)

    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var stackView: UIStackView!

    private let disposeBag = DisposeBag()

    private weak var item: ProgressItem? {
        didSet {
            self.disposeBag.dispose()
            self.item?.onInvalidation
                .observe { [weak self] in
                    self?.reload()
                }
                .disposeWith(self.disposeBag)
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
        guard let progressItem = item as? ProgressItem else {
            Logger.error("\(Self.self) expected to receive a ProgressItem, but \(item) was passed")
            return
        }

        self.item = progressItem
    }

    // MARK: - Methods (Private)

    private func updateViewContent() {
        self.updateProgressViews(for: item?.state)
        self.updateFooterView()
    }

    private func applyStyle() {
        self.label.numberOfLines = 0
        self.label.font = .preferredFont(forTextStyle: .body)
    }

    private func reload() {
        self.updateViewContent()
        self.delegate?.updateContainerHeight(for: self)
    }

    private func updateProgressViews(for status: ProgressItem.State?) {
        let status = status ?? .idle
        self.label.textColor = .systemGray
        switch status {
        case .idle:
            self.label.text = nil
            self.label.isHidden = true
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        case .progress(let message):
            self.label.text = message
            self.label.isHidden = message?.isEmpty != false
            self.activityIndicator.startAnimating()
            self.activityIndicator.isHidden = false
        case .success(let message):
            self.label.text = message
            self.label.isHidden = message?.isEmpty != false
            if #available(iOS 13.0, *) {
                self.label.textColor = .label
            } else {
                self.label.textColor = .black
            }
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        case .failure(let message):
            self.label.text = message
            self.label.isHidden = message?.isEmpty != false
            self.label.textColor = .systemRed
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
}
