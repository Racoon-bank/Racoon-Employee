//
//  UserDto.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//

import Foundation

public struct UserDto: Decodable, Sendable {
    public let id: UUID
    public let username: String
    public let email: String?

    
    public let role: UserRoleDto
    public let isBlocked: Bool

    public init(
        id: UUID,
        username: String,
        email: String?,
        role: UserRoleDto = .unknown,
        isBlocked: Bool = false
    ) {
        self.id = id
        self.username = username
        self.email = email
        self.role = role
        self.isBlocked = isBlocked
    }

    private enum CodingKeys: String, CodingKey {
        case id, username, email, role, isBlocked
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try c.decode(UUID.self, forKey: .id)
        self.username = try c.decode(String.self, forKey: .username)
        self.email = try c.decodeIfPresent(String.self, forKey: .email)

        
        self.role = try c.decodeIfPresent(UserRoleDto.self, forKey: .role) ?? .unknown
        self.isBlocked = try c.decodeIfPresent(Bool.self, forKey: .isBlocked) ?? false
    }
}
