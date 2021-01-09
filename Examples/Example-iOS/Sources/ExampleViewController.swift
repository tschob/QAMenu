//
//  ExampleViewController.swift
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
import QAMenuCatalog
import QAMenuUIKit

class ExampleViewController: UITableViewController {

    // MARK: - Properties (Private)

    private var catalogQAMenu: QAMenu?
    private var showcaseQAMenu: QAMenu?
    private var simpleProjectQAMenu: QAMenu?

    @IBOutlet private weak var openShowcaseButton: UIButton!
    @IBOutlet private weak var openCatalogButton: UIButton!
    @IBOutlet private weak var openSimpleProjectButton: UIButton!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        QAMenu.Log.logLevel = .verbose

        self.updateShowButtonsState()
    }

    @IBAction private func open(_ sender: Any) {
        self.showcaseQAMenu?.show()
    }

    // MARK: -

    private func updateShowButtonsState() {
        self.openShowcaseButton.isEnabled = self.showcaseQAMenu != nil
        self.openCatalogButton.isEnabled = self.catalogQAMenu != nil
        self.openSimpleProjectButton.isEnabled = self.simpleProjectQAMenu != nil
    }

    // MARK: - User Interaction

    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        switch (indexPath.section, indexPath.row) {
        case (_, 1):
            return true
        case (1, 2):
            return self.openShowcaseButton.isEnabled
        case (2, 2):
            return self.openCatalogButton.isEnabled
        case (3, 2):
            return self.openSimpleProjectButton.isEnabled
        default:
            break
        }
        return false
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (1, 1):
            self.setupShowcaseQAMenu()
        case (1, 2):
            self.showcaseQAMenu?.show()
        case (2, 1):
            self.setupCatalogQAMenu()
        case (2, 2):
            self.catalogQAMenu?.show()
        case (3, 1):
            self.setupSimpleProjectQAMenu()
        case (3, 2):
            self.simpleProjectQAMenu?.show()
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)

        self.updateShowButtonsState()
    }

    private func setupShowcaseQAMenu() {
        self.showcaseQAMenu = QAMenu(pane: ShowcaseItemsFactory.makeRootPane(), presenterType: QAMenuUIKitPresenter.self)
        if let presenter = self.showcaseQAMenu?.presenter as? QAMenuUIKitPresenter {
            presenter.ui.register(CustomPaneViewController.self, for: CustomPane.self)
        }
    }

    private func setupCatalogQAMenu() {
        self.catalogQAMenu = QAMenu(
            pane: RootPane(title: .static("QA Menu Catalog"), groups: QAMenu.Catalog.all),
            presenterType: QAMenuUIKitPresenter.self
        )
    }

    private var simpleProjectCacheEnabled = true
    private var simpleProjectCachedImagesCount = 50

    private func setupSimpleProjectQAMenu() {
        let customUserDefaults = UserDefaults(suiteName: "Custom User Defaults")
        customUserDefaults?.set(true, forKey: "Example Key")

        let cacheGroup = ItemGroup(title: .static("App Cache"), items: [
            BoolItem(
                title: .static("Enable cache"),
                value: .computed({ [weak self] in
                    return self?.simpleProjectCacheEnabled ?? false
                }),
                onValueChange: { [weak self] value, _, result in
                    guard let self = self else {
                        result(.failure("Object was released from memory"))
                        return
                    }
                    self.simpleProjectCacheEnabled = value
                    result(.success)
                }
            ),
            StringItem(
                title: .static("Cached images"),
                value: .computed({ [weak self] in
                    guard let self = self else { return nil }
                    return String(describing: self.simpleProjectCachedImagesCount)
                })
            ),
            ButtonItem(
                title: .static("Reset image cache"),
                action: { [weak self] (item: ButtonItem, _) in
                    item.status = .progress("Deleting cache")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self?.simpleProjectCachedImagesCount = 0
                        item.status = .idle
                        item.parentGroup?.invalidate()
                    }
                }
            )
        ])
        let groups: [Group] = [
            QAMenu.Catalog.AppInfo.group(),
            cacheGroup,
            QAMenu.Catalog.Preferences.group()
        ]
        self.simpleProjectQAMenu = QAMenu(
            pane: RootPane(title: .static("Simple Project"), groups: groups),
            presenterType: QAMenuUIKitPresenter.self
        )
    }
}
