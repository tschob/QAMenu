//
//  FooterViewSupportingTests.swift
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

class FooterViewSupportingTests: XCTestCase {

    var sut: FooterViewSupportingMock!

    override func setUpWithError() throws {
        self.sut = FooterViewSupportingMock()
    }

    // MARK: - setupFooterView

    func test_setupFooterView_insertsFooterLabel() throws {
        sut._footerText = "Footer"

        self.sut.setupFooterView()

        let labels = self.sut.footerContainer.arrangedSubviews.filter { $0 is UILabel }
        XCTAssertEqual(labels.count, 1)
    }

    func test_setupFooterView_whenHavingNoFooter_insertsFooterLabel() throws {
        self.sut.setupFooterView()

        let labels = self.sut.footerContainer.arrangedSubviews.filter { $0 is UILabel }
        XCTAssertEqual(labels.count, 1)
    }

    func test_setupFooterView_whenCallingTwice_doesNotAddAdditionalLabel() throws {
        self.sut.setupFooterView()
        self.sut.setupFooterView()

        let labels = self.sut.footerContainer.arrangedSubviews.filter { $0 is UILabel }
        XCTAssertEqual(labels.count, 1)
    }

    // MARK: - updateFooterView

    func test_updateFooterView_whenNotHavingFooter_hidesLabel() throws {
        self.sut.setupFooterView()
        self.sut.updateFooterView()

        let label = self.sut.footerContainer.arrangedSubviews.first(where: { $0 is UILabel })
        XCTAssertTrue(label!.isHidden)
    }

    func test_updateFooterView_whenHavingFooter_showsLabel() throws {
        self.sut._footerText = "Footer"
        self.sut.setupFooterView()
        self.sut.updateFooterView()

        let label = self.sut.footerContainer.arrangedSubviews.first(where: { $0 is UILabel })
        XCTAssertFalse(label!.isHidden)
    }

    func test_updateFooterView_whenDidNotSetupFooter_hasNoLabel() throws {
        self.sut._footerText = "Footer"
        self.sut.updateFooterView()

        let labels = self.sut.footerContainer.arrangedSubviews.filter { $0 is UILabel }
        XCTAssertEqual(labels.count, 0)
    }

    func test_updateFooterView_afterAddingFooter_showsabel() throws {
        self.sut.setupFooterView()
        self.sut.updateFooterView()

        self.sut._footerText = "Footer"
        self.sut.updateFooterView()

        let label = self.sut.footerContainer.arrangedSubviews.first(where: { $0 is UILabel })
        XCTAssertFalse(label!.isHidden)
    }
}
