//
//  Catalog.Device+Accessibility.swift
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

#if canImport(UIKit)

import Foundation
import UIKit
import QAMenu

public extension QAMenu.Catalog.Device {

    enum Accessibility: CatalogGroup {

        public static var all: [Group] {
            return [
                group()
            ]
        }

        public static func group(title: Dynamic<String?> = .static("Accessibility")) -> ItemGroup {
            let accessiblitySettings = UIAccessibility.settingsDictionary.map { (setting: (key: String, value: Bool)) -> StringItem in
                let title = setting.key.formattedAccessiblitySettingString()
                return StringItem(
                    title: .static(title),
                    value: .computed({ setting.value ? "Yes" : "No" }),
                    footerText: nil,
                    layoutType: .static(.horizontal(.singleLine))
                )
            }
            return ItemGroup(
                title: title,
                items: accessiblitySettings
            )
        }
    }
}

public extension UIAccessibility {

    static var settingsDictionary: [(String, Bool)] {
        var all: [(String, Bool)] = [
            ("isVoiceOverRunning", UIAccessibility.isBoldTextEnabled),
            ("isMonoAudioEnabled", UIAccessibility.isMonoAudioEnabled),
            ("isClosedCaptioningEnabled", UIAccessibility.isClosedCaptioningEnabled),
            ("isInvertColorsEnabled", UIAccessibility.isInvertColorsEnabled),
            ("isGuidedAccessEnabled", UIAccessibility.isGuidedAccessEnabled),
            ("isBoldTextEnabled", UIAccessibility.isBoldTextEnabled),
            ("isGrayscaleEnabled", UIAccessibility.isGrayscaleEnabled),
            ("isReduceTransparencyEnabled", UIAccessibility.isReduceTransparencyEnabled),
            ("isReduceMotionEnabled", UIAccessibility.isReduceMotionEnabled),
            ("isDarkerSystemColorsEnabled", UIAccessibility.isDarkerSystemColorsEnabled),
            ("isSwitchControlRunning", UIAccessibility.isSwitchControlRunning),
            ("isSpeakSelectionEnabled", UIAccessibility.isSpeakSelectionEnabled),
            ("isSpeakScreenEnabled", UIAccessibility.isSpeakScreenEnabled),
            ("isShakeToUndoEnabled", UIAccessibility.isShakeToUndoEnabled),
            ("isAssistiveTouchRunning", UIAccessibility.isAssistiveTouchRunning)
        ]

        if #available(iOS 13.0, *) {
            all.append(("isVideoAutoplayEnabled", UIAccessibility.isVideoAutoplayEnabled))
            all.append(("shouldDifferentiateWithoutColor", UIAccessibility.shouldDifferentiateWithoutColor))
            all.append(("isOnOffSwitchLabelsEnabled", UIAccessibility.isOnOffSwitchLabelsEnabled))
        }
        return all
    }
}

private extension String {

    func formattedAccessiblitySettingString() -> String {
        var formatted = self.replacingOccurrences(
            of: "([A-Z])",
            with: " $1",
            options: .regularExpression,
            range: range(of: self)
        )
            .trimmingCharacters(in: .whitespacesAndNewlines).capitalized
        formatted = formatted.replacingOccurrences(of: "Is ", with: "")
        formatted = formatted.replacingOccurrences(of: "Should ", with: "")
        formatted = formatted.replacingOccurrences(of: " Enabled", with: "")
        formatted = formatted.replacingOccurrences(of: " Running", with: "")
        return formatted
    }
}

#endif
