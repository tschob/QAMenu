//
//  TextAttributesUIKitTests.swift
//
//  Created by Hans Seiffert on 07.03.21.
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

import XCTest
@testable import QAMenuUIKit
import QAMenu

class TextAttributesUIKitTests: XCTestCase {

    // MARK: - TextStyle

    func test_textAttributesTextStyle_whenLargeTitle_returnsLargeTitle() throws {
        XCTAssertEqual(TextAttributes.TextStyle.largeTitle.asUIFontTextStyle, .largeTitle)
    }

    func test_textAttributesTextStyle_whenTitle1_returnsTitle1() throws {
        XCTAssertEqual(TextAttributes.TextStyle.title1.asUIFontTextStyle, .title1)
    }

    func test_textAttributesTextStyle_whenTitle2_returnsTitle2() throws {
        XCTAssertEqual(TextAttributes.TextStyle.title2.asUIFontTextStyle, .title2)
    }

    func test_textAttributesTextStyle_whenTitle3_returnslTitle3() throws {
        XCTAssertEqual(TextAttributes.TextStyle.title3.asUIFontTextStyle, .title3)
    }

    func test_textAttributesTextStyle_whenHeadline_returnsHeadline() throws {
        XCTAssertEqual(TextAttributes.TextStyle.headline.asUIFontTextStyle, .headline)
    }

    func test_textAttributesTextStyle_whenSubheadline_returnsSubheadline() throws {
        XCTAssertEqual(TextAttributes.TextStyle.subheadline.asUIFontTextStyle, .subheadline)
    }

    func test_textAttributesTextStyle_whenBody_returnsBody() throws {
        XCTAssertEqual(TextAttributes.TextStyle.body.asUIFontTextStyle, .body)
    }

    func test_textAttributesTextStyle_whenCallout_returnsCallout() throws {
        XCTAssertEqual(TextAttributes.TextStyle.callout.asUIFontTextStyle, .callout)
    }

    func test_textAttributesTextStyle_whenFootnote_returnsFootnote() throws {
        XCTAssertEqual(TextAttributes.TextStyle.footnote.asUIFontTextStyle, .footnote)
    }

    func test_textAttributesTextStyle_whenCaption1_returnsCaption1() throws {
        XCTAssertEqual(TextAttributes.TextStyle.caption1.asUIFontTextStyle, .caption1)
    }

    func test_textAttributesTextStyle_whenCaption2_returnsCaption2() throws {
        XCTAssertEqual(TextAttributes.TextStyle.caption2.asUIFontTextStyle, .caption2)
    }

    // MARK: - LineBreak

    func test_textAttributesLineBreak_whenWrapByCharacter_returnsByCharWrapping() throws {
        XCTAssertEqual(TextAttributes.LineBreak.wrapByCharacter.asNSLineBreakMode, .byCharWrapping)
    }

    func test_textAttributesLineBreak_whenWrapByWord_returnsByWordWrapping() throws {
        XCTAssertEqual(TextAttributes.LineBreak.wrapByWord.asNSLineBreakMode, .byWordWrapping)
    }
}
