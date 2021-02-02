//
//  QAMenuConfigurationItem.swift
//
//  Created by Hans Seiffert on 30.01.21.
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
import QAMenuUtils

// MARK: - QAMenuConfigurationItemSetterMode

public enum QAMenuConfigurationItemSetterMode {
    case initialValue
    case forceReplace
}

// MARK: - QAMenuConfigurationStorageProvider

public protocol QAMenuConfigurationStorageProvider {
    func set(_ value: Any?, forKey defaultName: String)
    func string(forKey defaultName: String) -> String?
}

// MARK: - QAMenuConfigurationItem

@propertyWrapper
public struct QAMenuConfigurationItem<Value: QAMenuConfigurationItemStorable> {
    internal let key: String
    internal let defaultValue: Value
    internal var configurationStorage: QAMenuConfigurationStorageProvider?

    public init(
        key: String,
        defaultValue: Value
    ) {
        self.key = key
        self.defaultValue = defaultValue
    }

    public var wrappedValue: Value {
        get {
            guard let configurationStorage = self.configurationStorage else {
                // swiftlint:disable:next line_length
                Logger.error("You need to provide `configurationStorage` before accessing the wrapped value of \(self)! The default value will be returned instead.")
                return defaultValue
            }
            // Read value from UserDefaults
            if let rawValue = configurationStorage.string(forKey: self.key), let value = Value(stringValue: rawValue) {
                return value
            } else {
                return defaultValue
            }
        }
        set {
            // Set value to UserDefaults
            configurationStorage?.set(newValue.toString, forKey: self.key)
        }
    }

    internal mutating func setup(for qaMenu: QAMenu) {
        // Inject the configuration storage manually as property wrappers don't allow the usage of `self` yet
        let userDefaults = UserDefaults(
            suiteName: "\(qaMenu.identifier) configuration"
        ) ?? UserDefaults.standard
        self.configurationStorage = userDefaults
    }

    internal var wasValueInitiallySet: Bool {
        return self.configurationStorage?.string(forKey: self.key) != nil
    }

    internal mutating func updateValue(with newValue: Value, mode: QAMenuConfigurationItemSetterMode) {
        switch mode {
        case .initialValue:
            if !self.wasValueInitiallySet {
                self.wrappedValue = newValue
            }
        case .forceReplace:
            self.wrappedValue = newValue
        }
    }
}

// MARK: - UserDefaults + QAMenuConfigurationStorageProvider

extension UserDefaults: QAMenuConfigurationStorageProvider {}
