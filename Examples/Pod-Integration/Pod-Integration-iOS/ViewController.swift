//
//  ViewController.swift
//  Example-Pod-Integration
//
//  Created by Hans Seiffert on 20.09.20.
//  Copyright © 2020 Hans Seiffert. All rights reserved.
//

import UIKit
import QAMenu
import QAMenuCatalog
import QAMenuUIKit

class ViewController: UIViewController {

    var qaMenu: QAMenu?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.qaMenu = QAMenu(pane: RootPane(groups: QAMenu.Catalog.all), presenterType: QAMenuUIKitPresenter.self)
    }

    @IBAction private func showQAMenu(_ sender: Any) {
        self.qaMenu?.show()
    }
}
