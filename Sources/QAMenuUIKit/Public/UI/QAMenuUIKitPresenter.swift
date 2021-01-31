//
//  QAMenuUIKitPresenter.swift
//
//  Created by Hans Seiffert on 30.05.20.
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

open class QAMenuUIKitPresenter: QAMenuPresenter {

    // MARK: - Properties (Public)

    open var dismissBehavior: QAMenuDismissBehavior {
        didSet {
            self.lifecycleManager.dismissBehavior = dismissBehavior
        }
    }

    open var ui = QAMenuPresenterUI()

    open var visiblePresentationContext: UINavigationController? {
        return window.rootViewController as? UINavigationController
    }

    // MARK: - Properties (Internal)

    internal var state: QAMenuState = .closed

    internal weak var qaMenu: QAMenu?

    internal lazy var window: UIWindow = {
        if #available(iOS 13.0, *) {
            let windowScene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive })
            if let windowScene = windowScene as? UIWindowScene {
                return UIWindow(windowScene: windowScene)
            }
        }
        return UIWindow(frame: UIScreen.main.bounds)
    }()

    private lazy var lifecycleManager: QAMenuLifecycleManager = {
        return QAMenuLifecycleManager(presenter: self, dismissBehavior: dismissBehavior)
    }()

    // MARK: - Initialization

    public required init(qaMenu: QAMenu) {
        self.qaMenu = qaMenu
        self.dismissBehavior = .resetAfter(30)
        self.lifecycleManager.dismissBehavior = self.dismissBehavior
        self.registerDefaultElements()
    }

    private func setupWindow() {
        guard let qaMenu = self.qaMenu else {
            Logger.verbose("Trying to setup the qa menu window, but the qa menu object is nil")
            return
        }
        let paneRepresentable = self.ui.retrieve(for: type(of: qaMenu.pane))
        let uiRepresentation = paneRepresentable.make(for: qaMenu.pane, in: qaMenu)

        let navigationController = UINavigationController(rootViewController: uiRepresentation)

        if #available(iOS 13.0, *) {
            self.window.windowLevel = .alert + 1
        }
        self.window.rootViewController = navigationController
    }

    private func registerDefaultElements() {
        self.ui.register(PaneViewController.self, for: RootPane.self)
        self.ui.register(PaneViewController.self, for: Pane.self)
        self.ui.register(StringItemView.self, for: ChildPaneItem.self)
        self.ui.register(BooleanItemView.self, for: BoolItem.self)
        self.ui.register(StringItemView.self, for: StringItem.self)
        self.ui.register(ButtonItemView.self, for: ButtonItem.self)
        self.ui.register(PickableStringItemView.self, for: PickableStringItem.self)
    }

    // MARK: - Lifecycle

    deinit {
        Logger.verbose("deinit")
    }

    // MARK: - Methods (Public)

    open func toggleVisibility(completion: @escaping (_ newState: QAMenuState) -> Void) {
        if self.state == .open {
            self.hide(completion: {
                completion(.closed)
            })
        } else {
            self.show(completion: {
                completion(.open)
            })
        }
    }

    open func show(completion: @escaping () -> Void) {
        self.lifecycleManager.onQAMenuWillOpen()
        if self.window.rootViewController == nil {
            self.setupWindow()
        }
        self.window.makeKeyAndVisible()

        self.animate(to: .open, completion: {
            self.state = .open
            completion()
        })
    }

    open func hide(completion: @escaping () -> Void) {
        self.animate(to: .closed, completion: {
            self.state = .closed
            self.window.resignKey()
            self.lifecycleManager.onQAMenuWasClosed()
            completion()
        })
    }

    open func navigateToRootPane() {
        guard let navigationController = self.window.rootViewController as? UINavigationController,
            let paneUIRepresentation = navigationController.viewControllers.first as? RootPaneUIRepresentable else {
                Logger.error("Unexpected view hierarchy: Wasn't able to locate root pane in a UINavigationController")
                return
        }
        paneUIRepresentation.scrollToTop()
        navigationController.popToRootViewController(animated: true)
    }

    open func resetRootViewController() {
        self.window.rootViewController = nil
    }

    // MARK: - Methods (Private)

    private func animate(to state: QAMenuState, completion: @escaping () -> Void) {
        let openedFrame = UIScreen.main.bounds
        let closedFrame = UIScreen.main.bounds.offsetBy(dx: 0, dy: UIScreen.main.bounds.height)

        self.window.frame = (state == .open) ? closedFrame : openedFrame
        self.window.isHidden = false

        UIView.animateKeyframes(
            withDuration: 0.3,
            delay: 0,
            options: [.beginFromCurrentState, .calculationModeCubicPaced],
            animations: {
                self.window.frame = (state == .open) ? openedFrame : closedFrame
            },
            completion: { _ in
                self.window.isHidden = (state == .closed)
                completion()
            }
        )
    }
}
