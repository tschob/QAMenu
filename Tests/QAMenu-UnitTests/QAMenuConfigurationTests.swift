//
//  QAMenuConfigurationItemTests.swift
//
//  Created by Hans Seiffert on 31.01.21.
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
@testable import QAMenu

class QAMenuConfigurationItemTests: XCTestCase {

    private class Wrapper {

        @QAMenuConfigurationItem(key: "key", defaultValue: "default")
        var sut: String

        let qaMenu = QAMenu(
            identifier: "unittest",
            pane: RootPane(items: []),
            presenterType: MockQAMenuPresenter.self
        )

        // Expose property wrapper properties

        var key: String {
            return self._sut.key
        }

        var defaultValue: String {
            return self._sut.defaultValue
        }

        var configurationStorage: QAMenuConfigurationStorageProvider? {
            return self._sut.configurationStorage
        }

        // Expose property wrapper methods

        func setup(for qaMenu: QAMenu) {
            self._sut.setup(for: qaMenu)
        }

        var wasValueInitiallySet: Bool {
            return self._sut.wasValueInitiallySet
        }

        func updateValue(with newValue: String, mode: QAMenuConfigurationItemSetterMode) {
            self._sut.updateValue(with: newValue, mode: mode)
        }
    }

    private var wrapper: Wrapper!

    override func setUpWithError() throws {
        self.wrapper = Wrapper()
    }

    override func tearDownWithError() throws {
        UserDefaults().removePersistentDomain(forName: "unittest configuration")
        UserDefaults().removePersistentDomain(forName: "QAMenu configuration")
        self.wrapper = nil
    }

    func test_init_doesNotAddConfigurationStorage() throws {
        XCTAssertNil(self.wrapper.configurationStorage)
    }

    // MARK: - setup

    func test_setup_addsConfigurationStorage() throws {
        XCTAssertNil(self.wrapper.configurationStorage)

        self.wrapper.setup(for: self.wrapper.qaMenu)

        XCTAssertNotNil(self.wrapper.configurationStorage)
    }

    // MARK: - wrappedValue

    func test_wrappedValue_beforeSetupWasCalled_isDefaultValue() throws {
        self.wrapper.sut = "value"

        XCTAssertEqual(self.wrapper.sut, "default")
    }

    func test_wrappedValue_isValue() throws {
        self.wrapper.setup(for: self.wrapper.qaMenu)

        self.wrapper.sut = "value"

        XCTAssertEqual(self.wrapper.sut, "value")
    }

    func test_wrappedValue_whenSet_setsValueInSettingsProvider() throws {
        XCTAssertNil(self.wrapper.configurationStorage?.string(forKey: "key"))

        self.wrapper.setup(for: self.wrapper.qaMenu)

        self.wrapper.sut = "value"

        XCTAssertEqual(self.wrapper.configurationStorage?.string(forKey: "key"), "value")
    }

    func test_wrappedValue_afterSetupWasCalled_whenNoValidValueWasSet_isDefaultValue() throws {
        self.wrapper.setup(for: self.wrapper.qaMenu)
        self.wrapper.sut = "value"

        self.wrapper.configurationStorage?.set("invalid", forKey: "key")

        XCTAssertEqual(self.wrapper.sut, "default")
    }

    // MARK: - wrappedValue

    func test_wasValueInitiallySet_whenValueWasNotSet_returnsFalse() throws {
        self.wrapper.setup(for: self.wrapper.qaMenu)

        XCTAssertFalse(self.wrapper.wasValueInitiallySet)
    }

    func test_wasValueInitiallySet_whenValueWasSet_returnsTrue() throws {
        self.wrapper.setup(for: self.wrapper.qaMenu)
        self.wrapper.sut = "value"

        XCTAssertTrue(self.wrapper.wasValueInitiallySet)
    }

    // MARK: - updateValue

    func test_updateValue_whenModeIsInitialValueAndValueIsAlradySet_doesNotReplaceIt() throws {
        self.wrapper.setup(for: self.wrapper.qaMenu)
        self.wrapper.sut = "initial"

        self.wrapper.updateValue(with: "updated", mode: .initialValue)

        XCTAssertEqual(self.wrapper.sut, "initial")
    }

    func test_updateValue_whenModeIsInitialValueAndValueWasNotSet_doesReplaceIt() throws {
        self.wrapper.setup(for: self.wrapper.qaMenu)

        self.wrapper.updateValue(with: "updated", mode: .initialValue)

        XCTAssertEqual(self.wrapper.sut, "updated")
    }

    func test_updateValue_whenModeIsForceReplaceAndValueIsAlreadySet_doesReplaceIt() throws {
        self.wrapper.setup(for: self.wrapper.qaMenu)
        self.wrapper.sut = "initial"

        self.wrapper.updateValue(with: "updated", mode: .forceReplace)

        XCTAssertEqual(self.wrapper.sut, "updated")
    }

    func test_updateValue_whenModeIsForceReplaceAndValueWasNotSet_doesSetIt() throws {
        self.wrapper.setup(for: self.wrapper.qaMenu)

        self.wrapper.updateValue(with: "updated", mode: .forceReplace)

        XCTAssertEqual(self.wrapper.sut, "updated")
    }
}

// MARK: - String + QAMenuConfigurationItemStorable

extension String: QAMenuConfigurationItemStorable {

    public init?(stringValue: String) {
        if stringValue == "invalid" {
            return nil
        }
        self = stringValue
    }

    public var toString: String {
        return self
    }
}
