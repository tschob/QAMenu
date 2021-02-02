//
//  QAMenu.swift
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
import QAMenuUtils

open class QAMenu {

    // MARK: - Properties (Public)

    public let identifier: String

    open var trigger: Trigger

    open var onDidAppear: (() -> Void)?
    open var onDidDisappear: (() -> Void)?

    private var presenterType: QAMenuPresenter.Type
    open lazy var presenter: QAMenuPresenter = {
        return self.presenterType.init(qaMenu: self)
    }()

    // MARK: - Properties (Internal)

    public static var instances = [WeakBox<QAMenu>]()

    open private(set) var pane: RootPane?

    // MARK: - Initialization

    public init(
        identifier: String = "QAMenu",
        pane: RootPane? = nil,
        trigger: Trigger = .shake,
        presenterType: QAMenuPresenter.Type
    ) {
        self.trigger = trigger
        self.identifier = identifier
        self.presenterType = presenterType
        Self.instances.append(WeakBox(self))
        if let pane = pane {
            self.setRootPane(pane)
        }
    }

    deinit {
        Logger.verbose("deinit")
    }

    // MARK: - Setter

    public func setRootPane(_ pane: RootPane) {
        self.pane = pane
    }

    // MARK: -

    open func onShakeRecognized() {
        self.presenter.toggleVisibility { (newState: QAMenuState) in
            if newState == .closed {
                self.onDidDisappear?()
            } else if newState == .open {
                self.onDidAppear?()
            }
        }
    }

    @objc open func navigateToRootPane() {
        self.presenter.navigateToRootPane()
    }

    @objc open func show() {
        self.presenter.show {
            self.onDidAppear?()
        }
    }

    @objc open func hide() {
        self.presenter.hide {
            self.onDidDisappear?()
        }
    }
}
