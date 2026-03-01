//
//  User.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


import Foundation

public struct User: Identifiable, Sendable, Equatable {
    public let id: UUID
    public let username: String
    public let email: String?
    public let role: UserRole
    public let isBlocked: Bool

    public init(
        id: UUID,
        username: String,
        email: String?,
        role: UserRole,
        isBlocked: Bool,
    ) {
        self.id = id
        self.username = username
        self.email = email
        self.role = role
        self.isBlocked = isBlocked
    }
}
