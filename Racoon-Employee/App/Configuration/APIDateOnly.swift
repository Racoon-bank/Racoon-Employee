//
//  APIDateOnly.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//

import Foundation

public struct APIDateOnly: Codable, Sendable, Equatable {
    public let value: Date

    public init(_ value: Date) { self.value = value }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let s = try container.decode(String.self)

        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = TimeZone(secondsFromGMT: 0)
        f.dateFormat = "yyyy-MM-dd"

        guard let d = f.date(from: s) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid date-only format: \(s). Expected yyyy-MM-dd"
            )
        }
        self.value = d
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = TimeZone(secondsFromGMT: 0)
        f.dateFormat = "yyyy-MM-dd"

        try container.encode(f.string(from: value))
    }
}
