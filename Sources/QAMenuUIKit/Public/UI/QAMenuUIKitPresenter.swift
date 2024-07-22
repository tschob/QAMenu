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

    open var dismissBehavior: QAMenu.DismissBehavior {
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
        let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive })
        if let windowScene = windowScene as? UIWindowScene {
            return UIWindow(windowScene: windowScene)
        }
        return UIWindow(frame: UIScreen.main.bounds)
    }()

    private lazy var lifecycleManager: QAMenuLifecycleManager = {
        return QAMenuLifecycleManager(presenter: self, dismissBehavior: dismissBehavior)
    }()

    // MARK: - Initialization

    public required init(
        qaMenu: QAMenu,
        dismissBehavior: QAMenu.DismissBehavior
    ) {
        self.qaMenu = qaMenu
        self.dismissBehavior = dismissBehavior
        self.lifecycleManager.dismissBehavior = self.dismissBehavior
        self.registerDefaultElements()
    }

    private func setupWindow() {
        guard let qaMenu = self.qaMenu else {
            Logger.verbose("Trying to setup the qa menu window, but the qa menu object is nil")
            return
        }
        guard let rootPane = qaMenu.pane else {
            Logger.error("You need to set a root pane before using qa menu!")
            return
        }
        let paneRepresentable = self.ui.retrieve(for: type(of: rootPane))
        let uiRepresentation = paneRepresentable.make(for: rootPane, in: qaMenu)

        let navigationController = UINavigationController(rootViewController: uiRepresentation)

        self.window.windowLevel = .alert + 1
        self.window.rootViewController = navigationController
    }

    private func registerDefaultElements() {
        self.ui.register(PaneViewController.self, for: RootPane.self)
        self.ui.register(PaneViewController.self, for: Pane.self)
        self.ui.register(StringItemView.self, for: ChildPaneItem.self)
        self.ui.register(BooleanItemView.self, for: BoolItem.self)
        self.ui.register(StringItemView.self, for: StringItem.self)
        self.ui.register(StringItemView.self, for: EditableStringItem.self)
        self.ui.register(ButtonItemView.self, for: ButtonItem.self)
        self.ui.register(ProgressItemView.self, for: ProgressItem.self)
        self.ui.register(PickableStringItemView.self, for: PickableStringItem.self)
    }

    // MARK: - Lifecycle

    deinit {
        Logger.verbose("deinit")
    }

    // MARK: - Methods (Public)

    open func toggleVisibility(completion: @escaping (_ newState: QAMenuState) -> Void) {
        self.performHapticFeedback()
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
            // Make sure that the status bar style is updated for QAMenu
            self.visiblePresentationContext?.viewControllers.last?.setNeedsStatusBarAppearanceUpdate()
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
        let openedCenter = CGPoint(x: self.window.bounds.width / 2, y: self.window.bounds.height / 2)
        let closedCenter = openedCenter.applying(.init(translationX: 0, y: self.window.bounds.height))
        // Apply the animation start postion first to make sure that e.g. the initial opening is animated
        self.window.center = (state == .open) ? closedCenter: openedCenter
        self.window.isHidden = false

        UIView.animateKeyframes(
            withDuration: 0.3,
            delay: 0,
            options: [.beginFromCurrentState, .calculationModeCubicPaced],
            animations: {
                self.window.center = (state == .open) ? openedCenter : closedCenter
            },
            completion: { _ in
                self.window.isHidden = (state == .closed)
                completion()
            }
        )
    }

    private func performHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }
}
