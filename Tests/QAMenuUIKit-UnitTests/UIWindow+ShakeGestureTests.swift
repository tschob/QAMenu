//
//  UIWindow+ShakeGestureTests.swift
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
import QAMenuUtils

class UIWindowShakeGestureTests: XCTestCase {

    // MARK: - motionEnded

    func test_motionEnded_whenMotionIsShake_andQAMenuShakeEnabled_forwardsEvent() throws {
        let menu = QAMenuMock()
        menu.setTrigger([.shake], mode: .forceReplace)
        QAMenu.instances.append(WeakBox(menu))
        let sut = UIWindow()

        XCTAssertEqual(menu._onShakeRecognizedCount, 0)

        sut.motionEnded(.motionShake, with: nil)

        XCTAssertEqual(menu._onShakeRecognizedCount, 1)
    }

    func test_motionEnded_whenMotionIsNotShake_andQAMenuShakeEnabled_forwardsEvent() throws {
        let menu = QAMenuMock()
        menu.setTrigger([.shake], mode: .forceReplace)
        QAMenu.instances.append(WeakBox(menu))
        let sut = UIWindow()

        XCTAssertEqual(menu._onShakeRecognizedCount, 0)

        sut.motionEnded(.remoteControlPlay, with: nil)

        XCTAssertEqual(menu._onShakeRecognizedCount, 0)
    }

    func test_motionEnded_whenMotionIsShake_andQAMenuShakeDisabled_doesNotForwardsEvent() throws {
        let menu = QAMenuMock()
        menu.setTrigger([], mode: .forceReplace)
        QAMenu.instances.append(WeakBox(menu))
        let sut = UIWindow()

        XCTAssertEqual(menu._onShakeRecognizedCount, 0)

        sut.motionEnded(.motionShake, with: nil)

        XCTAssertEqual(menu._onShakeRecognizedCount, 0)
    }

    func test_motionEnded_whenMotionIsNotShake_andQAMenuShakeDisabled_doesNotForwardsEvent() throws {
        let menu = QAMenuMock()
        menu.setTrigger([], mode: .forceReplace)
        QAMenu.instances.append(WeakBox(menu))
        let sut = UIWindow()

        XCTAssertEqual(menu._onShakeRecognizedCount, 0)

        sut.motionEnded(.remoteControlBeginSeekingForward, with: nil)

        XCTAssertEqual(menu._onShakeRecognizedCount, 0)
    }

    func test_motionEnded_whenHavingMultipleMenus_forwardsOnlyToLastAddedInstance() throws {
        let menu1 = QAMenuMock()
        menu1.setTrigger([.shake], mode: .forceReplace)
        let menu2 = QAMenuMock()
        menu2.setTrigger([.shake], mode: .forceReplace)
        QAMenu.instances.append(WeakBox(menu2))
        QAMenu.instances.append(WeakBox(menu1))
        let sut = UIWindow()

        XCTAssertEqual(menu1._onShakeRecognizedCount, 0)
        XCTAssertEqual(menu2._onShakeRecognizedCount, 0)

        sut.motionEnded(.motionShake, with: nil)

        XCTAssertEqual(menu1._onShakeRecognizedCount, 1)
        XCTAssertEqual(menu2._onShakeRecognizedCount, 0)
    }

    func test_motionEnded_whenHavingMultipleMenus_butOnlyWithShakeEnavled_forwardsToEnabledMenu() throws {
        let menu1 = QAMenuMock()
        menu1.setTrigger([], mode: .forceReplace)
        let menu2 = QAMenuMock()
        menu2.setTrigger([.shake], mode: .forceReplace)
        QAMenu.instances.append(WeakBox(menu2))
        QAMenu.instances.append(WeakBox(menu1))
        let sut = UIWindow()

        XCTAssertEqual(menu1._onShakeRecognizedCount, 0)
        XCTAssertEqual(menu2._onShakeRecognizedCount, 0)

        sut.motionEnded(.motionShake, with: nil)

        XCTAssertEqual(menu1._onShakeRecognizedCount, 0)
        XCTAssertEqual(menu2._onShakeRecognizedCount, 1)
    }

    func test_motionEnded_whenHavingMultipleMenus_butMotionIsNotAShake_doesNotForwardsEvent() throws {
        let menu1 = QAMenuMock()
        menu1.setTrigger([.shake], mode: .forceReplace)
        let menu2 = QAMenuMock()
        menu2.setTrigger([.shake], mode: .forceReplace)
        QAMenu.instances.append(WeakBox(menu2))
        QAMenu.instances.append(WeakBox(menu1))
        let sut = UIWindow()

        XCTAssertEqual(menu1._onShakeRecognizedCount, 0)
        XCTAssertEqual(menu2._onShakeRecognizedCount, 0)

        sut.motionEnded(.remoteControlNextTrack, with: nil)

        XCTAssertEqual(menu1._onShakeRecognizedCount, 0)
        XCTAssertEqual(menu2._onShakeRecognizedCount, 0)
    }
}
