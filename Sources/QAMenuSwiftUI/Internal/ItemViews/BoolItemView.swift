//
//  BoolItemView.swift
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

import SwiftUI
import QAMenu
import QAMenuUtils
import Combine

struct BoolItemView: View {

    @ObservedObject var item: BoolItem

    @State var isOn: Bool

    @State var showDialog: Bool = false
    @State var dialogContent: DialogContent?

    init(item: BoolItem) {
        self.item = item
        self.isOn = item.value.unboxed
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(alignment: .center) {
                Text(item.title.unboxed)
                Spacer(minLength: 15)
                Toggle("", isOn: .init(
                    get: { isOn },
                    set: {
                        item.changeValue(to: $0)
                    }
                ))
                    .labelsHidden()
                    .fixedSize()
            }
            .font(.body)
        }
        .onReceive(item.onInvalidationSubject) { val in
            isOn = item.value.unboxed
        }
    }
}

#if DEBUG

#if canImport(QAMenuExampleItems)

import QAMenuExampleItems

struct BoolItemView_Previews: PreviewProvider {
    static var previews: some View {
        let groups = BoolItemAdvancedExamplesFactory().makePane().groups
        List {
            ForEach(groups.indices, id: \.self) { groupIndex in
                let group = groups[groupIndex]
                Section(header: Text(group.title?.unboxed ?? "")) {
                    ForEach(group.items.unboxed.indices, id: \.self) { itemIndex in
                        let item = group.items.unboxed[itemIndex]
                        if let boolItem = item as? BoolItem {
                            BoolItemView(item: boolItem)
                                .background(Color.white)
                        }
                    }
                }
            }
        }
    }
}

#endif

#endif
