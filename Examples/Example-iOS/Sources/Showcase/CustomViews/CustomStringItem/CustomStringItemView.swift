//
//  CustomStringItemView.swift
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

import UIKit
import QAMenu
import QAMenuUIKit

class CustomStringItemView: NibView, ItemUIRepresentable {

    // MARK: - Properties (Internal)

    var reuseIdentifier: String {
        return "CustomStringItemView"
    }

    override var nib: UINib {
        return UINib(nibName: Self.nibName, bundle: .main)
    }

    weak var delegate: ItemUIRepresentableDelegate?

    var footerText: Dynamic<String?>? {
        return item?.footerText
    }

    weak var item: StringItem?

    // MARK: - Properties (Private)

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
    @IBOutlet private weak var stackView: UIStackView!

    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle

    func prepareForReuse() {
        self.disposeBag.dispose()
        self.item = nil
    }

    // MARK: -

    func setItem(_ item: Item) {
        guard let item = item as? CustomStringItem else { return }
        self.item = item
        self.item?.onInvalidation
            .observe { [weak self] in
                self?.reload()
            }
            .disposeWith(self.disposeBag)
        self.reload()
    }

    private func reload() {
        self.titleLabel.text = item?.title?()
        self.titleLabel.sizeToFit()
        self.valueLabel.text = item?.value?()

        self.delegate?.updateContainerHeight(for: self)
    }
}
