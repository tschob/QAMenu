//
//  PaneViewController.swift
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
import QAMenuUtils

internal class PaneViewController: UIViewController {

    // MARK: - Properties (Internal)

    internal var pane: Pane {
        didSet {
            self.reloadItems(for: nil)
        }
    }

    internal private(set) var qaMenu: QAMenu

    private var presenter: QAMenuUIKitPresenter {
        guard let presenter = self.qaMenu.presenter as? QAMenuUIKitPresenter else {
            fatalError("Presenter is not of expected type `QAMenuUIKitPresenter`")
        }
        return presenter
    }

    // MARK: - Properties (Private)

    private var tableView: UITableView?
    private var searchController: UISearchController?

    private var disposeBag = DisposeBag()

    private var data = [Group]() {
        didSet {
            self.loadPane()
        }
    }

    private var tableViewStyle: UITableView.Style {
        if #available(iOS 13.0, *) {
            return .insetGrouped
        } else {
            return .grouped
        }
    }

    private var searchQuery: String?

    // MARK: - Initialization

    internal init(pane: Pane, qaMenu: QAMenu) {
        self.pane = pane
        self.data = pane.groups
        self.qaMenu = qaMenu
        super.init(nibName: nil, bundle: nil)
    }

    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initTableView() {
        let tableView = UITableView(frame: self.view.frame, style: self.tableViewStyle)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = CGFloat(44)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])

        tableView.register(ContainerTableViewCell.self, forCellReuseIdentifier: UnsupportedItemView(frame: .zero).reuseIdentifier)

        self.tableView = tableView
    }

    private func setupSearch() {
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController?.searchResultsUpdater = self
        self.searchController?.dimsBackgroundDuringPresentation = false
        self.tableView?.keyboardDismissMode = .onDrag

        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = self.searchController
            self.navigationItem.hidesSearchBarWhenScrolling = false
            self.navigationItem.searchController?.isActive = false
        } else {
            self.tableView?.tableHeaderView = self.searchController?.searchBar
        }
    }

    // MARK: - Lifecycle

    override internal func viewDidLoad() {
        super.viewDidLoad()

        self.initTableView()

        self.setupNavigationItems(for: self.pane, in: self.qaMenu)

        if self.pane.isSearchable {
            self.setupSearch()
        }

        self.loadPane()

        self.pane.onIsPresented()
    }

    // MARK: - Loading

    private func loadPane() {
        self.disposeBag.dispose()
        self.addObserver(for: self.pane)

        self.presenter.ui.items.values.forEach { (itemType: ItemUIRepresentable.Type) in
            let reuseIdentifier = itemType.init(frame: .zero).reuseIdentifier
            tableView?.register(ContainerTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        }

        self.title = self.pane.title()
        self.tableView?.reloadData()
    }

    private func reloadItems(for search: String?) {
        self.data = Searcher.filter(self.pane.groups, with: search)
    }

    private func addObserver(
        for pane: Pane
    ) {
        pane.groups.forEach { group in
            self.observeInvalidatable(group)
            self.observeDialogTriggerable(group as? DialogTrigger)
            group.items.unboxed.forEach { item in
                self.observeDialogTriggerable(item as? DialogTrigger)
                self.observeNavigationTrigger(item as? NavigationTrigger)
            }
        }
    }

    private func observeInvalidatable(
        _ invalidatable: Invalidatable?
    ) {
        invalidatable?.onInvalidation
            .observe { [weak self] _ in
                self?.reloadItems(for: self?.searchQuery)
            }
            .disposeWith(self.disposeBag)
    }

    private func observeDialogTriggerable(
        _ dialogTriggerable: DialogTrigger?
    ) {
        dialogTriggerable?.onPresentDialog
            .observe { [weak self] dialogContent in
                self?.showDialog(dialogContent)
            }
            .disposeWith(self.disposeBag)
    }

    private func observeNavigationTrigger(
        _ navigationTrigger: NavigationTrigger?
    ) {
        navigationTrigger?.onNavigateBack
            .observe { [weak self] completion in
                CATransaction.begin()
                CATransaction.setCompletionBlock(completion)
                self?.navigationController?.popViewController(animated: true)
                CATransaction.commit()
            }
            .disposeWith(self.disposeBag)
    }

    // MARK: - Dialog

    private func showDialog(_ dialogContent: DialogContent) {
        let alert = UIAlertController(
            title: dialogContent.title,
            message: dialogContent.message,
            preferredStyle: .alert
        )
        let closeButton = UIAlertAction(
            title: "Okay",
            style: .default,
            handler: nil
        )
        alert.addAction(closeButton)
        self.present(alert, animated: true)
    }

    // MARK: - Helper

    fileprivate func item(at indexPath: IndexPath) -> Item {
        return self.data[indexPath.section].items.unboxed[indexPath.row]
    }

    internal func cellFor(item: Item, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = self.reuseIdentifier(for: item)
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        if let cell = cell as? ContainerTableViewCell {
            if let selectable = item as? Selectable {
                cell.disclousureIndicatorView?.isHidden = !selectable.selectionOutcome.shouldShowNavigationElement
            } else {
                cell.disclousureIndicatorView?.isHidden = true
            }
            if let view = cell.containedView {
                view.setItem(item)
            } else {
                let view = self.presenter.ui.retrieve(for: type(of: item)).init(frame: .zero)
                view.setItem(item)
                cell.insertViewIfNeeded(view)
                view.delegate = self
            }
        }
        return cell
    }

    private func reuseIdentifier(for item: Item) -> String {
        let viewType = self.presenter.ui.retrieve(for: type(of: item))
        let reuseIdentifier = viewType.init(frame: .zero).reuseIdentifier
        return reuseIdentifier
    }
}

// MARK: - UISearchResultsUpdating

extension PaneViewController: UISearchResultsUpdating {

    internal func updateSearchResults(for searchController: UISearchController) {
        let validatedQuery = Searcher.validatedQuery(from: searchController.searchBar.text)
        self.searchQuery = validatedQuery
        self.reloadItems(for: validatedQuery)
    }
}

// MARK: - PaneUIKitRepresentable

extension PaneViewController: PaneUIKitRepresentable {

    internal static func make(for pane: Pane, in qaMenu: QAMenu) -> PaneUIKitRepresentable {
        return PaneViewController(pane: pane, qaMenu: qaMenu)
    }
}

// MARK: - RootPaneUIRepresentable

extension PaneViewController: RootPaneUIRepresentable {

    internal func scrollToTop() {
        guard let tableView = self.tableView else {
            Logger.warning("scrollToTop was called but tableView nil")
            return
        }
        tableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: -200), animated: false)
    }
}

// MARK: - ItemUIRepresentableDelegate

extension PaneViewController: ItemUIRepresentableDelegate {

    internal var presentationContext: UIViewController {
        self
    }

    internal func updateContainerHeight(for elementView: ItemUIRepresentable?) {
        guard self.tableView?.superview != nil, self.tableView?.window != nil else {
            Logger.verbose("updateTableViewCellHeights is called while the table view is not visible on the screen")
            return
        }
        UITableView.setAnimationsEnabled(false)
        self.tableView?.beginUpdates()
        self.tableView?.endUpdates()
        UITableView.setAnimationsEnabled(true)
    }
}

// MARK: - UITableViewDataSource

extension PaneViewController: UITableViewDataSource {

    internal func numberOfSections(in tableView: UITableView) -> Int {
        return self.data.count
    }

    internal func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let title = self.data[safe: section]?.title?(), !title.isEmpty else {
            return nil
        }
        return title
    }

    internal func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard let text = self.data[safe: section]?.footerText?(), !text.isEmpty else {
            return nil
        }
        return text
    }

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data[section].items.unboxed.count
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.cellFor(item: self.item(at: indexPath), tableView: tableView, indexPath: indexPath)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension PaneViewController: UITableViewDelegate {

    internal func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if let item = self.item(at: indexPath) as? Selectable {
            return item.isSelectable
        }
        if let item = self.item(at: indexPath) as? Shareable {
            return item.isSharingEnabled
        }
        return false
    }

    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let item = self.item(at: indexPath) as? Selectable else {
            Logger.verbose("UITableView row at index \(indexPath) was selectable but the the cell is not \(Selectable.self)")
            return
        }

        switch item.selectionOutcome {
        case .action(let actionClosure):
            actionClosure(self.qaMenu)
        case .custom(let customClosure):
            customClosure()
        case .navigationWithPane(let paneClosure, let beforeNavigation):
            let pane = paneClosure()
            let paneUIKitRepresentable = self.presenter.ui.retrieve(for: type(of: pane))
            let viewController = paneUIKitRepresentable.make(for: pane, in: self.qaMenu)
            viewController.setupNavigationItems(in: self.qaMenu)
            beforeNavigation(pane)
            show(viewController, sender: nil)
        case .navigationWithPaneRepresentable(let paneRepresentableClosure, let beforeNavigation):
            let paneRepresentable = paneRepresentableClosure()
            guard let viewController = paneRepresentable as? (UIViewController & PaneRepresentable) else {
                // swiftlint:disable:next line_length
                Logger.error("PaneRepresentable \(String(describing: paneRepresentable)) couldn't be converted into an instance of type (UIViewController & PaneRepresentable)")
                return
            }
            viewController.setupNavigationItems(in: self.qaMenu)
            beforeNavigation(paneRepresentable)
            show(viewController, sender: nil)
        }
    }
}
