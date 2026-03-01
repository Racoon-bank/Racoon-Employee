//
//  EmployeeUsersRepository.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//

import Foundation

public protocol EmployeeUsersRepository: Sendable {
    func getAllUsers() async throws -> [UserDto]
    func createUser(username: String, email: String?, password: String) async throws -> UserDto
    func register(username: String, email: String?, password: String) async throws -> UserDto
    func createEmployee(username: String, email: String?, password: String) async throws -> UserDto
    func banUser(id: UUID) async throws
}
