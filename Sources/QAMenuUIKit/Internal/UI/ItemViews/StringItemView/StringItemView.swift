//
//  StringItemView.swift
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

internal final class StringItemView: NibView, ItemView, ShareInteractionSupporting {

    // MARK: - Properties (Internal)

    internal weak var delegate: ItemUIRepresentableDelegate?

    internal var shareInteractionHandler: ShareInteractionHandling?

    internal var footerText: Dynamic<String?>? {
        return item?.footerText
    }

    internal var footerContainer: UIStackView {
        return self.stackView
    }

    internal var textEditorType: SingleLineTextEditorControllerProtocol.Type = SingleLineTextEditorController.self

    internal var textEditor: SingleLineTextEditorControllerProtocol?

    // MARK: - Properties (Private)

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var textStackView: UIStackView!

    private let disposeBag = DisposeBag()

    private weak var item: StringItem? {
        didSet {
            self.disposeBag.dispose()
            self.item?.onInvalidation
                .observe { [weak self] in
                    self?.reload()
                }
                .disposeWith(self.disposeBag)
            self.shareInteractionHandler?.shareable = self.item
            if let editableStringItem = item as? EditableStringItem {
                editableStringItem.onShouldEdit = { [weak self] item in
                    self?.onShouldEdit(item)
                }
            }
            self.updateViewContent()
        }
    }

    // MARK: - Lifecycle

    override internal func initFromNib() {
        super.initFromNib()
        self.applyStyle()
        self.setupFooterView()

        self.shareInteractionHandler = ShareInteractionHandler(
            shareable: nil,
            view: self,
            present: { [weak self] present in
                guard let presentationContext = self?.delegate?.presentationContext else {
                    return
                }
                present(presentationContext)
            }
        )
    }

    internal func prepareForReuse() {
        self.item = nil
    }

    internal func setItem(_ item: Item) {
        guard let stringItem = item as? StringItem else {
            Logger.error("\(Self.self) expected to receive a StringItem, but \(item) was passed")
            return
        }
        self.item = stringItem
    }

    // MARK: - Methods (Private)

    private func updateViewContent() {
        self.updateLayout()

        if let item = item {
            self.titleLabel.text = item.title?()
            self.titleLabel.font = .preferredFont(forTextStyle: item.titleTextAttributes.unboxed.textStyle.asUIFontTextStyle)
            self.valueLabel.text = item.value?() ?? item.valueFallbackString
            self.valueLabel.font = .preferredFont(forTextStyle: item.valueTextAttributes.unboxed.textStyle.asUIFontTextStyle)
        } else {
            self.titleLabel.text = nil
            self.titleLabel.font = .preferredFont(forTextStyle: .body)
            self.valueLabel.text = nil
            self.valueLabel.font = .preferredFont(forTextStyle: .body)
        }

        updateFooterView()
    }

    private func reload() {
        self.updateViewContent()
        self.delegate?.updateContainerHeight(for: self)
    }

    private func updateLayout() {
        guard let item = self.item else {
            self.applyHorizontalLayout()
            self.applyLineCountLayout(for: .singleLine)
            self.setNeedsLayout()
            return
        }
        let layoutType = item.layoutType()
        switch layoutType {
        case .vertical(let lineCount):
            self.applyVerticalLayout()
            self.applyLineCountLayout(for: lineCount)
        case .horizontal(let lineCount):
            self.applyHorizontalLayout()
            self.applyLineCountLayout(for: lineCount)
        }
        self.textStackView.setNeedsLayout()
    }

    private func applyStyle() {
        if #available(iOS 13.0, *) {
            self.titleLabel.textColor = .label
        } else {
            self.titleLabel.textColor = .black
        }
        self.titleLabel.font = .preferredFont(forTextStyle: .body)
        self.valueLabel.textColor = .systemGray
        self.valueLabel.font = .preferredFont(forTextStyle: .body)
    }

    private func applyHorizontalLayout() {
        self.textStackView.axis = .horizontal
        self.textStackView.alignment = .fill
        self.textStackView.distribution = .fillProportionally
        self.textStackView.spacing = CGFloat(15)
        self.valueLabel.textAlignment = .right
    }

    private func applyVerticalLayout() {
        self.textStackView.axis = .vertical
        self.textStackView.alignment = .fill
        self.textStackView.distribution = .fill
        self.textStackView.spacing = CGFloat(0)
        self.valueLabel.textAlignment = .left
    }

    private func applyLineCountLayout(for lineCount: StringItem.LayoutType.LineCount) {
        let numberOfLines = (lineCount == StringItem.LayoutType.LineCount.singleLine) ? 1 : 0
        self.titleLabel.numberOfLines = numberOfLines
        self.valueLabel.numberOfLines = numberOfLines
        if let item = self.item, numberOfLines != 1 {
            self.titleLabel.lineBreakMode = item.titleTextAttributes.unboxed.lineBreak.asNSLineBreakMode
            self.valueLabel.lineBreakMode = item.valueTextAttributes.unboxed.lineBreak.asNSLineBreakMode
        } else {
            self.titleLabel.lineBreakMode = .byTruncatingTail
            self.valueLabel.lineBreakMode = .byTruncatingTail
        }
    }

    // MARK: - Methods (Private) - Edit

    private func onShouldEdit(_ editableStringItem: EditableStringItem) {
        guard editableStringItem.isEditable.unboxed else {
            return
        }
        let textEditor = self.textEditorType.init(
            title: "Edit \(editableStringItem.title?.unboxed ?? "")",
            text: editableStringItem.value?.unboxed,
            onCancelEditing: { [weak self] textEditor in
                textEditor.dismiss()
                self?.textEditor = nil
            },
            onEndEditing: { (newValue, inputController) in
                editableStringItem.onValueChange?(newValue ?? "", editableStringItem) { [weak self] itemResult in
                    switch itemResult {
                    case .success:
                        editableStringItem.invalidate()
                    case .failure(let message):
                        self?.showEditValidationError(message)
                    }
                    inputController.dismiss()
                    self?.textEditor = nil
                }
            }
        )
        self.textEditor = textEditor
        self.delegate?.presentationContext.present(textEditor.viewController, animated: true)
    }

    private func showEditValidationError(_ message: String) {
        let dialogContent = DialogContent(
            title: "Error",
            message: message,
            closeButtonTitle: "Okay, I'll try again"
        )
        if let alertController = dialogContent.asUIAlertController() {
            self.delegate?.presentationContext.present(alertController, animated: true)
        }
    }
}
