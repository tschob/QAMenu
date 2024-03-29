//
//  BooleanItemView.swift
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
import QAMenuUtils

internal final class BooleanItemView: NibView, ItemView {

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
    @IBOutlet private weak var `switch`: UISwitch!
    @IBOutlet private weak var stackView: UIStackView!

    private let disposeBag = DisposeBag()

    private weak var item: BoolItem? {
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
        guard let boolItem = item as? BoolItem else {
            Logger.error("\(Self.self) expected to receive a BoolItem, but \(item) was passed")
            return
        }

        self.item = boolItem
    }

    // MARK: - Methods (Private)

    private func updateViewContent() {
        self.titleLabel.text = item?.title()
        self.titleLabel.sizeToFit()
        self.sizeToFit()
        self.switch.isOn = item?.value() ?? false
        self.updateFooterView()
    }

    private func applyStyle() {
        self.titleLabel.numberOfLines = 0
        if #available(iOS 13.0, *) {
            self.titleLabel.textColor = .label
        } else {
            self.titleLabel.textColor = .black
        }
        self.titleLabel.font = .preferredFont(forTextStyle: .body)
    }

    private func reload() {
        self.updateViewContent()
        self.delegate?.updateContainerHeight(for: self)
    }

    @IBAction private func onSwitchValueChanged(_ sender: Any) {
        item?.changeValue(to: self.switch.isOn)
    }
}
