//
//  StringItemView.swift
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

struct StringItemView: View {

    @ObservedObject var item: StringItem

    @State var showShareSheet = false

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 15) {
                let mode = AdaptiveStackMode(layoutType: item.layoutType.unboxed)
                AdaptiveStack(mode: mode, horizontalAlignment: .leading, verticalAlignment: .top) {
                    Text(item.title?.unboxed ?? "")
                        .lineLimit(item.layoutType.unboxed.lineCount == .singleLine ? 1 : nil)
                    if mode == .horizontal {
                        Spacer(minLength: 15)
                            .border(.blue, width: 1)
                            .allowsHitTesting(true)
                    }
                    Text(item.value?.unboxed ?? item.valueFallbackString)
                        .foregroundColor(.gray)
                        .lineLimit(item.layoutType.unboxed.lineCount == .singleLine ? 1 : nil)
                        .multilineTextAlignment(mode == .horizontal ? .trailing : .leading)

                }
                .font(item.titleTextAttributes.unboxed.textStyle.asFont)
            }
        }
    }
}

#if DEBUG

#if canImport(QAMenuExampleItems)

import QAMenuExampleItems

struct StringItemView_Previews: PreviewProvider {
    static var previews: some View {
        let groups = StringItemAdvancedExamplesFactory.makePane().groups
        List {
            ForEach(groups.indices, id: \.self) { groupIndex in
                let group = groups[groupIndex]
                Section(header: Text(group.title?.unboxed ?? "")) {
                    ForEach(group.items.unboxed.indices, id: \.self) { itemIndex in
                        let item = group.items.unboxed[itemIndex]
                        if let stringItem = item as? StringItem {
                            StringItemView(item: stringItem)
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
