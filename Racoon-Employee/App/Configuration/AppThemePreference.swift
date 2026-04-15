//
//  AppThemePreference.swift
//  Racoon-Employee
//
//  Created by dark type on 30.03.2026.
//

import Foundation
import SwiftUI

public enum AppThemePreference: String, Codable, Sendable, Equatable {
    case system
    case light
    case dark
}
extension AppThemePreference {
    init(profileTheme: Theme?) {
        switch profileTheme {
        case .Light:
            self = .light
        case .Dark:
            self = .dark
        case nil:
            self = .system
        }
    }
}
public enum Theme: String, Codable, Sendable {
    case Light
    case Dark
}
extension AppThemePreference {
    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}
