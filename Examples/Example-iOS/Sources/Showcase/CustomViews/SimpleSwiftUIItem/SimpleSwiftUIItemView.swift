//
//  SimpleSwiftUIItemView.swift
//
//  Created by Hans Seiffert on 13.05.21.
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
import SwiftUI
import QAMenu

// MARK: - SimpleSwiftUIView

struct SimpleSwiftUIItemView: View {

    private var item: SimpleSwiftUIItem

    init?(item: Item) {
        guard let item = item as? SimpleSwiftUIItem else {
            return nil
        }
        self.item = item
    }

    var body: some View {
        VStack {
            Text(item.message)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(item.response)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.yellow, .purple]),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
    }
}

// MARK: - Preview

#if DEBUG

struct SimpleSwiftUIItemView_Previews: PreviewProvider {
    static var previews: some View {
        let stringItem = StringItem(
            title: .static("Title text"),
            value: .static("Value text")
        )
        SimpleSwiftUIItemView(item: stringItem)
    }
}

#endif
