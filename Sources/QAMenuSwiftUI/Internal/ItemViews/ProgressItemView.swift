//
//  ProgressItemView.swift
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

struct ProgressItemView: View {

    @ObservedObject var item: ProgressItem

    var body: some View {
        HStack(alignment: .center) {
            if let message = item.message {
                let color: Color = {
                    switch item.state {
                    case .idle,
                            .success:
                        return .black
                    case .progress:
                        return .gray
                    case .failure:
                        return .red
                    }
                }()
                Text(message)
                    .padding(.trailing, 5)
                    .foregroundColor(color)
                Spacer()
            }
            if case .progress = item.state {
                ProgressView()
            }

        }
        .frame(maxWidth: .infinity)
        .font(.body)
        .onReceive(item.onInvalidationSubject) { value in
            item.objectWillChange.send()
        }
    }
}

#if DEBUG

#if canImport(QAMenuExampleItems)

import QAMenuExampleItems

struct ProgressItemView_Previews: PreviewProvider {
    static var previews: some View {
        let groups = ProgressItemAdvancedExamplesFactory.makePane().groups
        List {
            ForEach(groups.indices, id: \.self) { groupIndex in
                let group = groups[groupIndex]
                Section(header: Text(group.title?.unboxed ?? "")) {
                    ForEach(group.items.unboxed.indices, id: \.self) { itemIndex in
                        let item = group.items.unboxed[itemIndex]
                        if let progressItem = item as? ProgressItem {
                            ProgressItemView(item: progressItem)
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
