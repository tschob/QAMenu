//
//  ButtonItemAdvancedExamplesFactory.swift
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

import Foundation
import QAMenu

public class ButtonItemAdvancedExamplesFactory {

    public init() {}

    public func makePane() -> Pane {

        let group_1 = ItemGroup(items: .static([
            ButtonItem(title: .static("Print to console"), action: { _, _  in
                print("Printing to console")
            }),
            ButtonItem(
                title: .static("Print to console (Delayed)"),
                action: { (item: ButtonItem, _) in
                    item.status = .progress("Preparing to print to console")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        print("Printing to console")
                        item.status = .idle
                    }
                },
                footerText: .static("Printing to the console is delayed for 2s. A progress is shown that indicates the background work.")
            )
        ]))

        let group_2 = ItemGroup(title: .static("Dynamic height examples"), items: .static([
            ButtonItem(
                title: .static("This button has a very long title. The reason is to demonstrate the multine behaviour."),
                action: { _, _ in }
            ),
            ButtonItem(
                title: .static("This button has a very long title. The reason is to demonstrate the multine behaviour."),
                action: { (item: ButtonItem, _) in
                    item.status = .progress("Short progress text")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        item.status = .idle
                    }
                },
                footerText: .static("This example demonstrate a multiline button title with a one line progress message.")
            ),
            ButtonItem(
                title: .static("Button with Short title"),
                action: { (item: ButtonItem, _) in
                    item.status = .progress("This button has a long progress message. The reason is to show the multiline behaviour.")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        item.status = .idle
                    }
                },
                footerText: .static("This example demonstrate a one line button title with a multiline progress message.")
            )
        ]))

        let pane = Pane(
            title: .static("ButtonItem"),
            groups: [
                group_1,
                group_2
            ]
        )
        return pane
    }
}
