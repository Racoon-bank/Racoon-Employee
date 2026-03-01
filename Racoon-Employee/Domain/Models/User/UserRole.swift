//
//  UserRole.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


public enum UserRole: Sendable, Equatable {
    case client
    case employee
    case unknown(String)

    public var title: String {
        switch self {
        case .client: return "Client"
        case .employee: return "Employee"
        case .unknown(let raw): return raw
        }
    }
}
