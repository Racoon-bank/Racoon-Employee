//
//  AppSettingsStorage.swift
//  Racoon-Employee
//
//  Created by dark type on 30.03.2026.
//

import Foundation

public protocol AppSettingsStorage: Sendable {
    func load() -> AppSettings
    func save(_ settings: AppSettings)
}

public final class UserDefaultsAppSettingsStorage: AppSettingsStorage, @unchecked Sendable {
    private let defaults: UserDefaults
    private let key: String
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    public init(
        defaults: UserDefaults = .standard,
        key: String = "racoon.app.settings"
    ) {
        self.defaults = defaults
        self.key = key
    }

    public func load() -> AppSettings {
        guard
            let data = defaults.data(forKey: key),
            let settings = try? decoder.decode(AppSettings.self, from: data)
        else {
            return AppSettings()
        }
        return settings
    }

    public func save(_ settings: AppSettings) {
        guard let data = try? encoder.encode(settings) else { return }
        defaults.set(data, forKey: key)
    }
}
