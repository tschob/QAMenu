//
//  PaneRepresentable+UIViewController.swift
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

// MARK: - PaneRepresentable + UIViewController

extension PaneRepresentable where Self: UIViewController {

    public func setupNavigationItems(for pane: Pane, in qaMenu: QAMenu) {
        self.setupNavigationItems(isRoot: (pane is RootPane), in: qaMenu)
    }

    public func setupNavigationItems(isRoot: Bool = false, in qaMenu: QAMenu) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = isRoot ? .always : .never

        self.navigationItem.rightBarButtonItems = [
            .dm_hideQAMenu(in: qaMenu)
        ]
    }
}
