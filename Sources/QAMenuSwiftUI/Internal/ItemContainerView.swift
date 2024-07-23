//
//  ItemContainerView.swift
//
//  Created by Hans Seiffert on 27.03.22.
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

import SwiftUI
import Combine
import QAMenu

struct ItemContainerView<Content: View>: View {

    @ObservedObject var item: Item

    @ViewBuilder var content: Content

    @State private var showChildPane: Pane? = nil
    @State private var shouldShowChildPane = false

    // MARK: - Dialog Support

    @State var showDialog: Bool = false
    @State var dialogContent: DialogContent?

    // MARK: - Share Gesture

    @State var showShareSheet = false
    @GestureState var isDetectingLongPress = false

    var longPress: some Gesture {
        LongPressGesture(minimumDuration: 1)
            .updating($isDetectingLongPress) { currentState, gestureState, transaction in
                gestureState = currentState
                transaction.animation = Animation.easeIn(duration: 2.0)
            }
            .onEnded { finished in
                showShareSheet = true
            }
    }

    var tap: some Gesture {
        #if !os(tvOS)
        TapGesture().onEnded { _ in
            if let selectableItem = item as? Item & Selectable {
                switch selectableItem.selectionOutcome {
                case .custom(let closure):
                    closure()
                case .navigationWithPane(let pane, let beforeNavigation):
                    let pane = pane()
                    beforeNavigation(pane)
                    showChildPane = pane
                    shouldShowChildPane = true
                case .navigationWithPaneRepresentable(_, _):
                    break
                }
            }
        }
        #else
        LongPressGesture()
        #endif
    }

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .leading) {
            if let childPane = showChildPane {
                NavigationLink(destination: PaneView(pane: childPane), isActive: $shouldShowChildPane ) { EmptyView() }
            }
            if let navigationTrigger = item as? NavigationTrigger {
                Button(action: {}) {
                    EmptyView()
                }
                .onReceive(navigationTrigger.onNavigateBackSubject) { completion in
                    shouldShowChildPane = false
                    completion()
                }
            }
            // A button is used to enable the cell highlighting in lists
            if self.shouldShowItemSelection(for: item) {
                Button(action: {}) {
                    EmptyView()
                }
            }
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .center) {
                        content
                    }
                    if let footerSupport = item as? FooterSupport,
                       let footerText = footerSupport.footerText?.unboxed,
                       footerText.isEmpty == false {
                        Text(footerText)
                            .foregroundColor(.gray)
                            .font(.footnote)
                            .padding(.top, 12)
                    }
                }
                .contentShape(Rectangle())
                #if !os(watchOS)
                if let selectable = (item as? Selectable)?.selectionOutcome {
                    switch selectable {
                    case .custom:
                        EmptyView()
                    case .navigationWithPane,
                            .navigationWithPaneRepresentable:
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                }
                #endif
            }
        }
        .highPriorityGesture((item as? Shareable)?.isSharingEnabled == true ? longPress : nil)
        // Also add tap gesture if the item is not selectable, but shareable. This is to make SwiftUI show the selection
        .highPriorityGesture(self.shouldShowItemSelection(for: item) ? tap : nil)
        .onReceive(item.onInvalidationSubject) { _ in
            item.objectWillChange.send()
        }
        .onReceive(item.onPresentDialogSubject) { dialogContent in
            showDialog = true
            self.dialogContent = dialogContent
        }
        .alert(isPresented: $showDialog) {
            if let alert = dialogContent?.asAlert() {
                return alert
            } else {
                return Alert(title: Text("Something went wrong"))
            }
        }
#if os(iOS)
        .popover(isPresented: $showShareSheet) {
            ShareSheetView(activityItems: [(item as? Shareable)?.shareContent ?? ""])
        }
#endif
    }
    
    private func shouldShowItemSelection(for item: Item) -> Bool {
        return (item as? Selectable)?.isSelectable == true || (item as? Shareable)?.isSharingEnabled == true
    }
}

extension Optional where Wrapped: Combine.Publisher {
    func orEmpty() -> AnyPublisher<Wrapped.Output, Wrapped.Failure> {
        self?.eraseToAnyPublisher() ?? Empty().eraseToAnyPublisher()
    }
}

#if DEBUG

#if canImport(QAMenuExampleItems)

import QAMenuExampleItems

struct ItemContainerView_Previews: PreviewProvider {
    static var previews: some View {
        let item = StringItem(
            title: .static("Title"),
            value: .static("value"),
            footerText: .static("Footer")
        )
        ItemContainerView(item: item) {
            StringItemView(item: item)
        }
        .frame(width: 200, height: 100)
    }
}

#endif

#endif
