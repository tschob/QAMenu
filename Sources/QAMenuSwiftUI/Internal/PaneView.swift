//
//  QAMenuView.swift
//
//  Created by Hans Seiffert on 19.03.22.
//
//  ---
//  MIT License
//
//  Copyright © 2022 Hans Seiffert
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

import QAMenu
import QAMenuUtils
import Foundation
import SwiftUI

public struct PaneView: View {

    @State var showingSheet = false

    @ObservedObject var pane: Pane

    @State private var searchQuery = ""

    // MARK: - Dialog Support

    @State var showDialog: Bool = false
    @State var dialogContent: DialogContent?

    var searchResults: [QAGroup] {
        Searcher.filter(self.pane.groups, with: searchQuery)
    }

    public init(pane: Pane) {
        self.pane = pane
    }

    public var body: some View {
        List {
            ForEach(searchResults.indices, id: \.self) { groupIndex in
                let group = searchResults[groupIndex]
                let headerView: AnyView = {
                    if let header = group.title?.unboxed, header.count > 0 {
                        return AnyView(Text(header))
                    } else {
                        return AnyView(EmptyView())
                    }
                }()
                let footerView: AnyView = {
                    if let footer = group.footerText?.unboxed, footer.count > 0 {
                        return AnyView(Text(footer))
                    } else {
                        return AnyView(EmptyView())
                    }
                }()
                Section(
                    header: headerView,
                    footer: footerView
                ) {
                    ForEach(group.items.unboxed.indices, id: \.self) { itemIndex in
                        let item = group.items.unboxed[itemIndex]
                        ItemContainerView(item: item) {
                            if let childPaneItem = item as? ChildPaneItem {
                                StringItemView(item: childPaneItem)
                            } else if let pickableStringItem = item as? PickableStringItem {
                                PickableStringItemView(item: pickableStringItem)
                            } else if let editableStringItem = item as? EditableStringItem {
                                EditableStringItemView(item: editableStringItem)
                            } else if let stringItem = item as? StringItem {
                                StringItemView(item: stringItem)
                            } else if let buttonItem = item as? ButtonItem {
                                ButtonItemView(item: buttonItem)
                            } else if let boolItem = item as? BoolItem {
                                BoolItemView(item: boolItem)
                            } else if let progressItem = item as? ProgressItem {
                                ProgressItemView(item: progressItem)
                            } else {
                                Text("Error: Unknown Item type")
                            }
                        }
                    }
                    
                    .onReceive(group.onInvalidationSubject) { value in
                        pane.objectWillChange.send()
                    }
                }
                .onReceive(group.onPresentDialogSubject) { dialogContent in
                    showDialog = true
                    self.dialogContent = dialogContent
                }
            }

        }
        #if os(iOS)
        .listStyle(.insetGrouped)
        #endif
        .onLoad {
            self.pane.onIsPresented()
        }
        .onReceive(pane.onInvalidationSubject) { value in
            pane.objectWillChange.send()
        }
        .alert(isPresented: $showDialog) {
            if let alert = dialogContent?.asAlert() {
                return alert
            } else {
                return Alert(title: Text("Something went wrong"))
            }
        }
        .navigationTitle(pane.title.unboxed ?? "")
        .if(pane.isSearchable) {
            if #available(iOS 15.0, macOS 12.0, watchOS 8.0, tvOS 15.0, *) {
                $0.searchable(text: $searchQuery)
            } else {
                $0
            }
        }
        .if(pane.isReloadable) {
            if #available(iOS 15.0, macOS 12.0, watchOS 8.0, tvOS 15.0, *) {
                $0.refreshable { @Sendable in
                    pane.onReload()
                }
            } else {
                $0
            }
        }
#if os(iOS)
        .navigationBarTitleDisplayMode(pane is RootPane ? .large : .inline)
#endif
    }
}

extension View {
    /// Closure given view if conditional.
    /// - Parameters:
    ///   - conditional: Boolean condition.
    ///   - content: Closure to run on view.
    @ViewBuilder func `if`<Content: View>(_ conditional: Bool = true, @ViewBuilder _ content: (Self) -> Content) -> some View {
        if conditional {
            content(self)
        } else {
            self
        }
    }
}

#if DEBUG

import QAMenuExampleItems
import QAMenuCatalog

private var qaMenu: QAMenu = {
    let catalogQAMenu = QAMenu(
        identifier: "Catalog QAMenu",
        presenterType: QAMenuSwiftUIPresenter.self
    )
    catalogQAMenu.setTrigger([], mode: .initialValue)
    catalogQAMenu.setDismissBehavior(.resetImmediately, mode: .initialValue)
    catalogQAMenu.setRootPane(
        RootPane(
            title: .static("QA Menu Catalog"),
            groups: QAMenu.Catalog.all(qaMenu: catalogQAMenu) + QAMenuExampleItems.BoolItemAdvancedExamplesFactory().makePane().groups
        )
    )
    return catalogQAMenu
}()

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        PaneView(pane: qaMenu.pane!)
    }
}

#endif
