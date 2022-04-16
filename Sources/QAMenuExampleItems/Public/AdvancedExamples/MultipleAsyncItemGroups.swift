//
//  MultipleAsyncItemGroups.swift
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

import Foundation
import QAMenu

public struct MultipleAsyncItemGroups {

    fileprivate static var groupOneItems: [StringItem] = []

    fileprivate static var groupTwoItems: [StringItem] = []

    fileprivate static var shouldStringItemsLoadingFail = true

    public static func makePane() -> Pane {
        let groupOne = ItemGroup(
            title: .static("Group One"),
            items: .async({ instance in
                instance.updateProgress(.init(state: .progress("Preparing ...")))
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.groupOneItems = [
                        StringItem(title: .static("String #1"), value: .static("1")),
                        StringItem(title: .static("String #2"), value: .static("2"))
                    ]
                    instance.complete(self.groupOneItems)
                }
            })
        )
        let groupTwo = ItemGroup(
            title: .static("Group Two"),
            items: .async({ instance in
                instance.updateProgress(.init(state: .progress("Loading ...")))
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    guard !self.shouldStringItemsLoadingFail else {
                        self.shouldStringItemsLoadingFail = false
                        instance.fail(
                            ProgressItem(state: .failure("Couldn't load group. Please try again.")),
                            onFailureOption: ButtonItem(
                                title: .static("Try Again"),
                                action: { _ in
                                    instance.load()
                                }
                            )
                        )
                        return
                    }
                    self.groupTwoItems = [
                        StringItem(title: .static("String 3"), value: .static("3")),
                        StringItem(title: .static("String #4"), value: .static("4"))
                    ]
                    instance.complete(self.groupTwoItems)
                }
            })
        )
        return Pane(
            title: .static("Multiple async item groups"),
            groups: [
                groupOne,
                groupTwo
            ]
        )
    }
}
