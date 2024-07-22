//
//  ChildPaneItem.swift
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

open class ChildPaneItem: StringItem, NavigationTrigger {

    public enum ChildType {
        case pane(() -> Pane)
        case paneRepresentable(() -> PaneRepresentable)
    }

    // MARK: - Properties (Public)

    public let childType: ChildType

    public let onNavigateBack = ObservableEvent<() -> Void>()
    public private(set) lazy var onNavigateBackSubject = PassthroughSubject<() -> Void, Never>()

    private var navigationDisposeBag = DisposeBag()

    // MARK: - Initialization

    public init(
        pane: @escaping () -> Pane,
        value: Dynamic<String?>? = nil,
        footerText: Dynamic<String?>? = nil,
        fallbackString: String = ""
    ) {
        self.childType = .pane(pane)
        super.init(
            title: .computed({ pane().title() }),
            value: value,
            footerText: footerText,
            fallbackString: fallbackString
        )
    }

    public init(
        title: Dynamic<String?>,
        paneRepresentable: @escaping () -> PaneRepresentable,
        value: Dynamic<String?>? = nil,
        footerText: Dynamic<String?>? = nil,
        fallbackString: String = ""
    ) {
        self.childType = .paneRepresentable(paneRepresentable)
        super.init(
            title: title,
            value: value,
            footerText: footerText,
            fallbackString: fallbackString
        )
    }

    // MARK: - NavigationTrigger

    private func observeNavigationTriggerInChildPane(_ pane: Pane) {
        navigationDisposeBag.dispose()
        let navigationTriggers = pane.groups.compactMap { $0 as? NavigationTrigger }
        navigationTriggers.forEach { navigationTrigger in
            navigationTrigger.onNavigateBack
                .observe({ [weak self] completion in
                    self?.navigateBack { [weak self] in
                        self?.invalidate()
                        completion()
                    }
                })
                .disposeWith(self.navigationDisposeBag)
        }
    }
}

// MARK: - ChildPaneItem + Selectable

extension ChildPaneItem: Selectable {

    open var isSelectable: Bool {
        return true
    }

    open var selectionOutcome: SelectionOutcome {
        switch self.childType {
        case .pane(let paneClosure):
            return .navigationWithPane(
                paneClosure,
                beforeNavigation: { [weak self] pane in
                    self?.observeNavigationTriggerInChildPane(pane)
                }
            )
        case .paneRepresentable(let paneRepresentableClosure):
            return .navigationWithPaneRepresentable(
                paneRepresentableClosure,
                beforeNavigation: { _ in }
            )
        }
    }
}
