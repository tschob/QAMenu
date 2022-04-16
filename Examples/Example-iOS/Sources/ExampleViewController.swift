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
import QAMenuExampleItems

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
        case (4, 0):
            return true
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
        case (4, 0):
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "ExampleViewController")
            self.present(viewController, animated: true, completion: nil)
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)

        self.updateShowButtonsState()
    }

    private func setupShowcaseQAMenu() {
        self.showcaseQAMenu = QAMenu(
            identifier: "Simple QAMenu",
            pane: ShowcaseItemsFactory.makeRootPane(
                customScreenChildPane: ShowcaseItemsFactory.CustomViews.ChildPane.customScreen,
                customViewsGroupChildPane: ChildPaneItem(pane: { CustomItemsAdvancedExamplesFactory().makePane() })
            ),
            presenterType: QAMenuUIKitPresenter.self
        )
        if let presenter = self.showcaseQAMenu?.presenter as? QAMenuUIKitPresenter {
            presenter.ui.register(CustomPaneViewController.self, for: CustomPane.self)
            presenter.ui.register(SwiftUIViewContainerView.self, for: SimpleSwiftUIItem.self)
            presenter.ui.register(CustomStringItemView.self, for: CustomStringItem.self)
        }
    }

    private func setupCatalogQAMenu() {
        self.catalogQAMenu = QAMenu(
            identifier: "Catalog QAMenu",
            presenterType: QAMenuUIKitPresenter.self
        )
        self.catalogQAMenu?.setTrigger([], mode: .initialValue)
        self.catalogQAMenu?.setDismissBehavior(.resetImmediately, mode: .initialValue)
        self.catalogQAMenu?.setRootPane(
            RootPane(
                title: .static("QA Menu Catalog"),
                groups: QAMenu.Catalog.all(qaMenu: self.catalogQAMenu)
            )
        )
    }

    private var simpleProjectCacheEnabled = true
    private var simpleProjectCachedImagesCount = 50

    private var simpleProjectAPIHost = "https://fancy.api.com"

    // swiftlint:disable:next function_body_length
    private func setupSimpleProjectQAMenu() {
        let customUserDefaults = UserDefaults(suiteName: "Custom User Defaults")
        customUserDefaults?.set(true, forKey: "Example Key")

        let cacheGroup = ItemGroup(
            title: .static("App Cache"),
            items: .static([
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
        )
        let backendGroup = ItemGroup(
            title: .static("Backend"),
            items: .static([
                EditableStringItem(
                    title: .static("Host"),
                    value: .computed({ [weak self] in
                        return self?.simpleProjectAPIHost
                    }),
                    onValueChange: { [weak self] (newValue, _, result) in
                        if newValue.hasPrefix("https://") {
                            self?.simpleProjectAPIHost = newValue
                            result(.success)
                        } else {
                            result(.failure("The host is invalid"))
                        }
                    }
                )
            ])
        )
        self.simpleProjectQAMenu = QAMenu(
            identifier: "Simple QAMenu",
            presenterType: QAMenuUIKitPresenter.self
        )
        let groups: [Group] = [
            QAMenu.Catalog.AppInfo.group(),
            cacheGroup,
            backendGroup,
            QAMenu.Catalog.Preferences.group(customPreferencesVisibility: .show(asChildPane: false)),
            QAMenu.Catalog.QAMenuConfiguration.group(qaMenu: self.simpleProjectQAMenu)
        ]
        self.simpleProjectQAMenu?.setRootPane(
            RootPane(title: .static("Simple Project"), groups: groups)
        )
    }
}
