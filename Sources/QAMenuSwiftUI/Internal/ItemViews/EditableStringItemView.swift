//
//  EditableStringItemView.swift
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

struct EditableStringItemView: View {

    @ObservedObject var item: EditableStringItem

    @State var showEditDialog: Bool = false
    @State private var textfield: String

    init(item: EditableStringItem) {
        self.item = item
        self.textfield = item.value?.unboxed ?? ""
    }

    var body: some View {
        StringItemView(item: item as StringItem)
#if !os(watchOS) && !os(tvOS)
            .popover(isPresented: $showEditDialog) {
                Text("Edit \(item.title?.unboxed ?? "String")")
                    .font(.headline).padding()
                TextField(item.title?.unboxed ?? "", text: $textfield, onCommit: {
                    showEditDialog = false
                    item.onValueChange?(textfield, item) { result in
                        if case .failure(let message) = result {
                            textfield = item.value?.unboxed ?? ""
                            item.presentDialog(DialogContent(title: "Error", message: message, closeButtonTitle: "Okay, I'll try again"))
                        }
                    }
                }).border(.gray, width: 1).cornerRadius(4).padding()
                HStack(alignment: .center) {
                    Button("Cancel") {
                        showEditDialog = false
                        textfield = item.value?.unboxed ?? ""
                    }.padding()
                    Button("Save") {
                        showEditDialog = false
                        item.onValueChange?(textfield, item) { result in
                            if case .failure(let message) = result {
                                textfield = item.value?.unboxed ?? ""
                                item.presentDialog(DialogContent(title: "Error", message: message, closeButtonTitle: "Okay, I'll try again"))
                            } else {
                                item.invalidate()
                            }
                        }
                    }.padding()
                }
            }
            .onReceive(item.onEditSubject) {
                if item.isEditable.unboxed {
                    showEditDialog = true
                }
            }
#endif
    }
}

#if DEBUG

#if canImport(QAMenuExampleItems)

import QAMenuExampleItems

struct EditableStringItemView_Previews: PreviewProvider {
    static var previews: some View {
        let groups = EditableStringItemAdvancedExamplesFactory.makePane().groups
        List {
            ForEach(groups.indices, id: \.self) { groupIndex in
                let group = groups[groupIndex]
                Section(header: Text(group.title?.unboxed ?? "")) {
                    ForEach(group.items.unboxed.indices, id: \.self) { itemIndex in
                        let item = group.items.unboxed[itemIndex]
                        if let editableStringItem = item as? EditableStringItem {
                            EditableStringItemView(item: editableStringItem)
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
