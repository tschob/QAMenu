//
//  Searcher.swift
//
//  Created by Hans Seiffert on 20.05.20.
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

public struct Searcher {

    public static func validatedQuery(from string: String?) -> String? {
        guard let string = string, !string.isEmpty else {
            return nil
        }
        return string
    }

    public static func filter(_ groups: [Group], with query: String?) -> [Group] {
        if let items = self.items(for: query, in: groups) {
            // Create a search result group if items are matching
            return [ItemGroup(items: .static(items))]
        } else {
            // Return the original groups if the search failing (no or empty query)
            return groups
        }
    }

    private static func items(for query: String?, in groups: [Group]) -> [Item]? {
        // Only return items if a not empty search query was given
        guard let validatedQuery = self.validatedQuery(from: query) else {
            return nil
        }
        // Collect all matching items
        return groups.flatMap { group in
            return group.items.unboxed.compactMap { (item: Item) -> Item? in
                return item.fulfillsSearch(query: validatedQuery) ? item : nil
            }
        }
    }
}
