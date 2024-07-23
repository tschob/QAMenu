//
//  ContentView.swift
//  Pod-Integration-watchOS-SwiftUI WatchKit Extension
//
//  Created by Hans Seiffert on 16.04.22.
//  Copyright © 2022 Hans Seiffert. All rights reserved.
//

import SwiftUI
import QAMenuSwiftUI
import QAMenuUtils
import QAMenuCatalog
import QAMenuExampleItems
import QAMenu

struct ContentView: View {

    @State var showQAMenu = false

    var body: some View {
        Button("Show QA Menu") {
            showQAMenu.toggle()
            Logger.logLevel = .verbose
        }
        .fullScreenCover(isPresented: $showQAMenu) {
            NavigationView {
                if let pane = self.qaMenu.pane {
                    PaneView(pane: pane)
                }
            }
        }
    }

    private var qaMenu: QAMenu = {
        let catalogQAMenu = QAMenu(
            identifier: "Catalog QAMenu",
            presenterType: QAMenuSwiftUIPresenter.self
        )
        catalogQAMenu.setTrigger([], mode: .initialValue)
        catalogQAMenu.setDismissBehavior(.resetImmediately, mode: .initialValue)
        catalogQAMenu.setRootPane(
            ShowcaseItemsFactory.makeRootPane()
        )
        return catalogQAMenu
    }()
}

#if DEBUG

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

#endif
