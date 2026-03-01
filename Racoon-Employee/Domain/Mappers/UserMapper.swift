//
//  UserMapper.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


enum UserMapper {
    static func toDomain(_ dto: UserDto) -> User {
        User(
            id: dto.id,
            username: dto.username,
            email: dto.email,
            role: mapRole(dto.role),
            isBlocked: dto.isBlocked
        )
    }

    private static func mapRole(_ dto: UserRoleDto) -> UserRole {
        switch dto {
        case .client: return .client
        case .employee: return .employee
        case .unknown: return .unknown("UNKNOWN")
        }
    }
}
