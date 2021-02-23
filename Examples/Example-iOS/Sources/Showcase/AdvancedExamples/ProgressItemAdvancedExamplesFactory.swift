//
//  ProgressItemAdvancedExamplesFactory.swift
//
//  Created by Hans Seiffert on 23.02.21.
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

// swiftlint:disable function_body_length

import QAMenu

struct ProgressItemAdvancedExamplesFactory {

    static var loopedProgressItem: ProgressItem?

    static func makePane() -> Pane {
        let pane = Pane(
            title: .static("ProgressItem"),
            groups: [
                ItemGroup(
                    title: .computed({ "Updated state" }),
                    items: .async({ delayed in
                        let loopedProgressItem = self.loopedProgressItem ?? ProgressItem()
                        delayed.complete([loopedProgressItem])
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            loopedProgressItem.state = .progress("Loading")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                loopedProgressItem.state = .success("Loaded with a long description message")
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    loopedProgressItem.state = .failure("Failed")
                                }
                            }
                        }
                    })
                ),
                ItemGroup(
                    title: .computed({ "Short messages" }),
                    items: .static([
                        ProgressItem(state: .idle),
                        ProgressItem(state: .progress("Progressing ...")),
                        ProgressItem(state: .success("Succeeded")),
                        ProgressItem(state: .failure("Failed"))
                    ])
                ),
                ItemGroup(
                    title: .computed({ "Long messages" }),
                    items: .static([
                        ProgressItem(state: .idle),
                        ProgressItem(state: .progress("Progressing with a long description message ...")),
                        ProgressItem(state: .success("Succeeded with a long description message")),
                        ProgressItem(state: .failure("Failed with a long description message"))
                    ])
                ),
                ItemGroup(
                    title: .computed({ "With Footer" }),
                    items: .static([
                        ProgressItem(state: .idle, footerText: .static("This is a footer message")),
                        ProgressItem(state: .progress("Progressing ..."), footerText: .static("This is a footer message")),
                        ProgressItem(state: .success("Succeeded"), footerText: .static("This is a footer message")),
                        ProgressItem(state: .failure("Failed"), footerText: .static("This is a footer message"))
                    ])
                ),
                ItemGroup(
                    title: .computed({ "No messages" }),
                    items: .static([
                        ProgressItem(state: .idle),
                        ProgressItem(state: .progress(nil)),
                        ProgressItem(state: .success(nil)),
                        ProgressItem(state: .failure(nil))
                    ])
                )
            ],
            isSearchable: true
        )
        return pane
    }
}
