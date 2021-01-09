//
//  CustomPaneViewController.swift
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

import UIKit
import QAMenu
import QAMenuUIKit

class CustomPaneViewController: UIViewController, PaneUIKitRepresentable {

    var pane: Pane
    var qaMenu: QAMenu

    // MARK: - Initialization

    init(pane: Pane, qaMenu: QAMenu) {
        self.pane = pane
        self.qaMenu = qaMenu
        super.init(nibName: "CustomPaneViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    static func make(for pane: Pane, in qaMenu: QAMenu) -> PaneUIKitRepresentable {
        return CustomPaneViewController(pane: pane, qaMenu: qaMenu)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = (pane as? CustomPane)?.color()
    }

    // MARK: -

    @IBAction private func pushToQAMenu(_ sender: Any) {
        guard let newPane = (self.pane as? CustomPane)?.childPane(),
            let presenter = self.qaMenu.presenter as? QAMenuUIKitPresenter else {
            return
        }
        let viewController = presenter.ui.retrieve(for: type(of: newPane)).make(for: newPane, in: self.qaMenu)
        self.show(viewController, sender: nil)
    }
}
