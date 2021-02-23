//
//  ItemGroupAdvancedExamplesFactory.swift
//
//  Created by Hans Seiffert on 22.02.21.
//
//  ---
//  MIT License
//
//  Copyright © 2021 Hans Seiffert
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

class ItemGroupAdvancedExamplesFactory {

    func makePane() -> Pane {
        let pane = Pane(
            title: .static("ItemGroup"),
            groups: [
                ItemGroup(
                    title: .static("Delayed Loading"),
                    items: .static([
                        makeDelayedLoadingExample(
                            identifier: "#1",
                            succeedsAfter: 0,
                            allowRetry: false,
                            shouldDismiss: false
                        ),
                        makeDelayedLoadingExample(
                            identifier: "#2",
                            succeedsAfter: 2,
                            allowRetry: true,
                            shouldDismiss: true
                        ),
                        makeDelayedLoadingExample(
                            identifier: "#3",
                            succeedsAfter: 1,
                            allowRetry: false,
                            shouldDismiss: true
                        )
                    ])
                )
            ]
        )
        return pane
    }

    private func makeDelayedLoadingExample(
        identifier: Swift.String,
        succeedsAfter: Int,
        allowRetry: Swift.Bool,
        shouldDismiss: Swift.Bool
    ) -> ChildPaneItem {
        let footer = "Loading fails for \(succeedsAfter) time(s); Shows a retry button: \(allowRetry ? "yes" : "no")"
        return ShowcaseItemsFactory.DetailedItemExamples.ItemGroups.delayedItems(
            identifier: identifier,
            succeedsAfter: succeedsAfter,
            allowRetry: allowRetry,
            footer: footer
        )
        .asChildPaneItem(footerText: .static(footer))
    }
}
