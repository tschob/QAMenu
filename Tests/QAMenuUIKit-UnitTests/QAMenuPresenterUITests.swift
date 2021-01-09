//
//  QAMenuPresenterUITests.swift
//
//  Created by Hans Seiffert on 19.11.20.
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

import XCTest
import QAMenu
@testable import QAMenuUIKit

// MARK: - CustomItem

class CustomItem: Item { }

// MARK: - CustomPane

class CustomPane: Pane {}

// MARK: - QAMenuPresenterUITests

class QAMenuPresenterUITests: XCTestCase {

    // MARK: - Panes

    func test_register_pane_addsToPanes() throws {
        let sut = QAMenuPresenterUI()

        sut.register(PaneViewController.self, for: Pane.self)

        XCTAssert(sut.panes[Pane.typeId] is PaneViewController.Type)
        XCTAssertEqual(sut.panes.count, 1)
    }

    func test_retrieve_pane_returnsPaneViewController() throws {
        let sut = QAMenuPresenterUI()
        sut.register(PaneViewController.self, for: Pane.self)

        XCTAssert(sut.retrieve(for: Pane.self) is PaneViewController.Type)
    }

    func test_register_rootPane_addsToPanes() throws {
        let sut = QAMenuPresenterUI()

        sut.register(CustomPaneViewController.self, for: RootPane.self)

        XCTAssert(sut.panes[RootPane.typeId] is CustomPaneViewController.Type)
        XCTAssertEqual(sut.panes.count, 1)
    }

    func test_retrieve_rootPane_returnsPaneViewController() throws {
        let sut = QAMenuPresenterUI()
        sut.register(PaneViewController.self, for: RootPane.self)

        XCTAssert(sut.retrieve(for: RootPane.self) is PaneViewController.Type)
    }

    func test_register_customPane_addsToPanes() throws {
        let sut = QAMenuPresenterUI()

        sut.register(CustomPaneViewController.self, for: CustomPane.self)

        XCTAssert(sut.panes[CustomPane.typeId] is CustomPaneViewController.Type)
        XCTAssertEqual(sut.panes.count, 1)
    }

    func test_retrieve_customPane_returnsUnsupportedPaneViewController() throws {
        let sut = QAMenuPresenterUI()
        sut.register(CustomPaneViewController.self, for: CustomPane.self)

        XCTAssert(sut.retrieve(for: CustomPane.self) is CustomPaneViewController.Type)
    }

    func test_register_multiplePanes_addsToPanes() throws {
        let sut = QAMenuPresenterUI()

        sut.register(PaneViewController.self, for: Pane.self)
        sut.register(CustomPaneViewController.self, for: CustomPane.self)

        XCTAssert(sut.panes[Pane.typeId] is PaneViewController.Type)
        XCTAssert(sut.panes[CustomPane.typeId] is CustomPaneViewController.Type)
        XCTAssertEqual(sut.panes.count, 2)
    }

    func test_retrieving_multiplePanes_returnsThem() throws {
        let sut = QAMenuPresenterUI()
        sut.register(PaneViewController.self, for: Pane.self)
        sut.register(CustomPaneViewController.self, for: CustomPane.self)

        XCTAssert(sut.retrieve(for: Pane.self) is PaneViewController.Type)
        XCTAssert(sut.retrieve(for: CustomPane.self) is CustomPaneViewController.Type)
    }

    func test_register_multiplePanesForSameType_replacesPane() throws {
        let sut = QAMenuPresenterUI()

        sut.register(UnsupportedPaneViewController.self, for: Pane.self)
        sut.register(PaneViewController.self, for: Pane.self)

        XCTAssert(sut.panes[Pane.typeId] is PaneViewController.Type)
        XCTAssertEqual(sut.panes.count, 1)
    }

    func test_retrieving_paneWhenReplacingItBefore_returnsUnsupportedPaneViewController() throws {
        let sut = QAMenuPresenterUI()
        sut.register(PaneViewController.self, for: Pane.self)
        sut.register(CustomPaneViewController.self, for: Pane.self)

        XCTAssert(sut.retrieve(for: Pane.self) is CustomPaneViewController.Type)
    }

    func test_retrieve_NotAddedPaneViewController_returnsUnsupportedItemView() throws {
        let sut = QAMenuPresenterUI()

        XCTAssert(sut.retrieve(for: Pane.self) is UnsupportedPaneViewController.Type)
    }

    // MARK: - Items

    func test_register_Item_addsToItems() throws {
        let sut = QAMenuPresenterUI()

        sut.register(BooleanItemView.self, for: Item.self)

        XCTAssert(sut.items[Item.typeId] is BooleanItemView.Type)
        XCTAssertEqual(sut.items.count, 1)
    }

    func test_retrieve_Item_returnsUnsupportedPaneViewController() throws {
        let sut = QAMenuPresenterUI()
        sut.register(BooleanItemView.self, for: Item.self)

        XCTAssert(sut.retrieve(for: Pane.self) is UnsupportedPaneViewController.Type)
    }

    func test_register_CustomItem_addsToItems() throws {
        let sut = QAMenuPresenterUI()

        sut.register(StringItemView.self, for: CustomItem.self)

        XCTAssert(sut.items[CustomItem.typeId] is StringItemView.Type)
        XCTAssertEqual(sut.items.count, 1)
    }

    func test_retrieve_CustomItem_returnsUnsupportedPaneViewController() throws {
        let sut = QAMenuPresenterUI()
        sut.register(StringItemView.self, for: CustomItem.self)

        XCTAssert(sut.retrieve(for: Pane.self) is UnsupportedPaneViewController.Type)
    }

    func test_register_StringItem_addsToItems() throws {
        let sut = QAMenuPresenterUI()

        sut.register(CustomItemView.self, for: StringItem.self)

        XCTAssert(sut.items[StringItem.typeId] is CustomItemView.Type)
        XCTAssertEqual(sut.items.count, 1)
    }

    func test_retrieve_StringItem_returnsCustomItemView() throws {
        let sut = QAMenuPresenterUI()
        sut.register(CustomItemView.self, for: StringItem.self)

        XCTAssert(sut.retrieve(for: StringItem.self) is CustomItemView.Type)
    }

    func test_register_MultipleItemViews_addsToItems() throws {
        let sut = QAMenuPresenterUI()

        sut.register(ButtonItemView.self, for: ButtonItem.self)
        sut.register(StringItemView.self, for: ChildPaneItem.self)

        XCTAssert(sut.items[ButtonItem.typeId] is ButtonItemView.Type)
        XCTAssert(sut.items[ChildPaneItem.typeId] is StringItemView.Type)
        XCTAssertEqual(sut.items.count, 2)
    }

    func test_retrieve_MultipleItemViews_returnsStringItemView() throws {
        let sut = QAMenuPresenterUI()
        sut.register(ButtonItemView.self, for: ButtonItem.self)
        sut.register(StringItemView.self, for: ChildPaneItem.self)

        XCTAssert(sut.retrieve(for: ButtonItem.self) is ButtonItemView.Type)
        XCTAssert(sut.retrieve(for: ChildPaneItem.self) is StringItemView.Type)
    }

    func test_register_MultipleItemViewsForSameItemType_replacesView() throws {
        let sut = QAMenuPresenterUI()

        sut.register(CustomItemView.self, for: StringItem.self)
        sut.register(UnsupportedItemView.self, for: StringItem.self)

        XCTAssert(sut.items[StringItem.typeId] is UnsupportedItemView.Type)
        XCTAssertEqual(sut.items.count, 1)
    }

    func test_retrieve_MultipleItemViewsForSameItemType_returnsUnsupportedItemView() throws {
        let sut = QAMenuPresenterUI()
        sut.register(CustomItemView.self, for: StringItem.self)
        sut.register(UnsupportedItemView.self, for: StringItem.self)

        XCTAssert(sut.retrieve(for: StringItem.self) is UnsupportedItemView.Type)
    }

    func test_retrieve_NotAddedItemView_returnsUnsupportedItemView() throws {
        let sut = QAMenuPresenterUI()

        XCTAssert(sut.retrieve(for: CustomItem.self) is UnsupportedItemView.Type)
    }
}
