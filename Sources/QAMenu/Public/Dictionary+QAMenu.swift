//
//  Dictionary+QAMenu.swift
//
//  Created by Hans Seiffert on 18.07.20.
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

public extension Dictionary where Key == String {

    func dm_toStringItems(
        layoutType: Dynamic<StringItem.LayoutType> = .static(.vertical(.autoGrow)),
        removeOptionalsIdentificationFromString: Bool = true
    ) -> [StringItem] {
        let items = self
            .sorted(by: { (lhs: (key: String, value: Value), rhs: (key: String, value: Value)) -> Bool in
                lhs.key.lowercased() < rhs.key.lowercased()
            })
            .map { (element: (key: String, value: Value)) -> StringItem in
                let value = stringRepresentation(
                    for: element.value,
                    removeOptionalsIdentificationFromString: removeOptionalsIdentificationFromString
                )
                return StringItem(
                    title: .static(element.key),
                    value: .static(value)
                )
                .withLayoutType(layoutType)
            }
        return items
    }

    func stringRepresentation(for value: Value, removeOptionalsIdentificationFromString: Bool) -> String? {
        guard removeOptionalsIdentificationFromString else {
            return String(describing: value)
        }
        guard let style = Mirror(reflecting: value).displayStyle,
            style == .optional else {
            return String(describing: value)
        }
        let string = String(describing: value)
        guard string != "nil" else {
            return nil
        }
        return string.replacingOccurrences(of: "Optional\\((.*)\\)", with: "$1", options: [.regularExpression])
    }
}
