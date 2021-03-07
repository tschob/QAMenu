//
//  MultipleAsyncPickerGroups.swift
//
//  Created by Hans Seiffert on 20.02.21.
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

// swiftlint:disable private_over_fileprivate

// MARK: - BackendURL

fileprivate struct BackendURL {
    let name: String
    let urlString: String

    static var selectedURL: BackendURL?

    var asPickableStringItem: PickableStringItem {
        PickableStringItem(
            identifier: .static(self.name),
            title: .static(self.name),
            value: .static(self.urlString),
            isSelected: .computed({
                BackendManager.current?.name == self.name
            })
        )
        .withValueTextAttributes(.static(.init(textStyle: .subheadline, lineBreak: .wrapByCharacter)))
    }
}

fileprivate struct BackendManager {

    static var current: BackendURL? = BackendURL(name: "Prod-1", urlString: "http://prod1.example.com")
}

// MARK: - MultipleAsyncPickerGroups

struct MultipleAsyncPickerGroups {

    fileprivate static var productionURLs: [BackendURL] = []

    fileprivate static var stagingURLs: [BackendURL] = []

    fileprivate static var shouldStagingLoadingFail = true

    // swiftlint:disable:next function_body_length
    static func makePane() -> Pane {
        let headerGroup = StringItem(
            title: .static("Current"),
            value: .computed({
                BackendManager.current?.urlString
            })
        )
        .withLayoutType(.static(.vertical(.autoGrow)))
        .withValueTextAttributes(.static(TextAttributes(textStyle: .subheadline, lineBreak: .wrapByCharacter)))
        .asItemGroup()
        let productionGroup = PickerGroup(
            title: .static("Production"),
            options: .async({ instance in
                instance.updateProgress(.init(state: .progress("Loading production URLs ...")))
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.productionURLs = [
                        BackendURL(name: "Prod-1", urlString: "http://prod1.example.com"),
                        BackendURL(name: "Prod-2", urlString: "http://prod2.with-a-very-long-subdomain.example.com"),
                        BackendURL(name: "Prod-3", urlString: "http://prod3.subdomain.example.com")
                    ]
                    instance.complete(self.productionURLs.map({ $0.asPickableStringItem }))
                }
            }),
            onPickedOption: { pickableItem, pickResult in
                let backendURL = productionURLs.first(where: { $0.name == pickableItem.identifier() })
                BackendManager.current = backendURL
                pickResult(.success(shouldDismiss: false))
            }
        )
        let stagingGroup = PickerGroup(
            title: .static("Staging"),
            options: .async({ instance in
                instance.updateProgress(.init(state: .progress("Loading staging URLs ...")))
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    guard !self.shouldStagingLoadingFail else {
                        self.shouldStagingLoadingFail = false
                        instance.fail(
                            ProgressItem(state: .failure("Couldn't load URLs. Please try again.")),
                            onFailureOption: ButtonItem(
                                title: .static("Try Again"),
                                action: { (_, _) in
                                    instance.load()
                                }
                            )
                        )
                        return
                    }
                    self.stagingURLs = [
                        BackendURL(name: "Stage-1", urlString: "http://stage1.example.com"),
                        BackendURL(name: "Stage-2", urlString: "http://stage2.example.com"),
                        BackendURL(name: "Stage-3 (invalid)", urlString: "http://stage3.example.com")
                    ]
                    instance.complete(self.stagingURLs.map({ $0.asPickableStringItem }))
                }
            }),
            onPickedOption: { pickableItem, pickResult in
                let backendURL = stagingURLs.first(where: { $0.name == pickableItem.identifier() })
                if backendURL?.name.contains("invalid") == true {
                    pickResult(.failure("Couldn't reach staging URL"))
                } else {
                    BackendManager.current = backendURL
                    pickResult(.success(shouldDismiss: false))
                }
            }
        )
        return Pane(
            title: .static("Multiple async picker groups"),
            groups: [
                headerGroup,
                productionGroup,
                stagingGroup
            ],
            isReloadable: true
        )
    }
}
