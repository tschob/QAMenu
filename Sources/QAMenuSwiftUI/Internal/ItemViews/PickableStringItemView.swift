//
//  PickableStringItemView.swift
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
import QAMenu

struct PickableStringItemView: View {

    @ObservedObject var item: PickableStringItem

    @State var showShareSheet = false

    var body: some View {
        Button(action: {
            if item.isSelectable {
                switch item.selectionOutcome {
                case .custom(let customClosure):
                    customClosure()
                default:
                    break
                }
            }
        }) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(item.title.unboxed)
                            .font(item.titleTextAttributes.unboxed.textStyle.asFont)
                            .foregroundColor(.primary)
                        if item.value?.unboxed?.isEmpty == false {
                            Text(item.value?.unboxed ?? "")
                                .foregroundColor(.gray)
                                .font(item.titleTextAttributes.unboxed.textStyle.asFont)
                        }
                    }
                    Spacer()
                    if item.isSelected.unboxed {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }

    @GestureState var isDetectingLongPress = false
    @State var completedLongPress = false

    var longPress: some Gesture {
        LongPressGesture(minimumDuration: 1)
            .updating($isDetectingLongPress) { currentState, gestureState,
                transaction in
                gestureState = currentState
                transaction.animation = Animation.easeIn(duration: 2.0)
            }
            .onEnded { finished in
                showShareSheet = true
                self.completedLongPress = finished
            }
    }
}

#if DEBUG

#if canImport(QAMenuExampleItems)

import QAMenuExampleItems

struct PickableStringItemView_Previews: PreviewProvider {
    static var previews: some View {
        let groups = PickerGroupAdvancedExamplesFactory().makePane().groups
        List {
            ForEach(groups.indices, id: \.self) { groupIndex in
                let group = groups[groupIndex]
                Section(header: Text(group.title?.unboxed ?? "")) {
                    ForEach(group.items.unboxed.indices, id: \.self) { itemIndex in
                        let item = group.items.unboxed[itemIndex]
                        if let pickableStringItem = item as? PickableStringItem {
                            PickableStringItemView(item: pickableStringItem)
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
