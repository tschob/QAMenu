//
//  ItemViewTests.swift
//
//  Created by Hans Seiffert on 24.11.20.
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

class ItemViewTests: XCTestCase {

    // MARK: - containerTableViewCell

    func test_containerTableViewCell_whenHavingNoParent_returnsNil() throws {
        let sut = CustomItemView()

        XCTAssertNil(sut.containerTableViewCell)
    }

    func test_containerTableViewCell_whenHavingNoContainerParent_returnsNil() throws {
        let sut = CustomItemView()

        let view = UIView()
        view.addSubview(sut)

        XCTAssertNil(sut.containerTableViewCell)
    }

    func test_containerTableViewCell_whenHavingDirectContainerParent_returnsContainer() throws {
        let sut = CustomItemView()

        let view = UIView()
        let container = ContainerTableViewCell()

        view.addSubview(container)
        container.addSubview(sut)

        XCTAssertNotNil(sut.containerTableViewCell)
    }

    func test_containerTableViewCell_whenHavingNonDirectContainerParent_returnsContainer() throws {
        let sut = CustomItemView()

        let view = UIView()
        let container = ContainerTableViewCell()

        container.addSubview(view)
        view.addSubview(sut)

        XCTAssertNotNil(sut.containerTableViewCell)
    }

    func test_containerTableViewCell_whenHavingOnlyContainerParent_returnsContainer() throws {
        let sut = CustomItemView()

        let container = ContainerTableViewCell()
        container.addSubview(sut)

        XCTAssertNotNil(sut.containerTableViewCell)
    }

    func test_containerTableViewCell_whenHavingMultipleContainerParents_returnsNearestContainer() throws {
        let sut = CustomItemView()

        let container1 = ContainerTableViewCell()
        let container2 = ContainerTableViewCell()

        container2.addSubview(container1)
        container1.addSubview(sut)

        XCTAssertEqual(sut.containerTableViewCell, container1)
    }
}
