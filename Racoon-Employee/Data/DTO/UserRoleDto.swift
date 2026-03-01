//
//  UserRoleDto.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


public enum UserRoleDto: String, Codable, Sendable {
    case client = "CLIENT"
    case employee = "EMPLOYEE"
    case unknown = "UNKNOWN"
}
