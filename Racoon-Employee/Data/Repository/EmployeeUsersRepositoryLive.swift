//
//  EmployeeUsersRepositoryLive.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//

import Foundation

public final class EmployeeUsersRepositoryLive: EmployeeUsersRepository {
    private let client: HTTPClient
    public init(client: HTTPClient) { self.client = client }

    public func getAllUsers() async throws -> [UserDto] {
        try await client.send(InfoRouter.getAllUsers, as: [UserDto].self)
    }

    public func createUser(username: String, email: String?, password: String) async throws -> UserDto {
        try await client.send(
            InfoRouter.createUser(username: username, email: email, password: password),
            as: UserDto.self
        )
    }

    public func register(username: String, email: String?, password: String) async throws -> UserDto {
        try await client.send(
            InfoRouter.register(username: username, email: email, password: password),
            as: UserDto.self
        )
    }

    public func createEmployee(username: String, email: String?, password: String) async throws -> UserDto {
        try await client.send(
            InfoRouter.createEmployee(username: username, email: email, password: password),
            as: UserDto.self
        )
    }

    public func banUser(id: UUID) async throws {
        try await client.sendNoResponse(InfoRouter.banUser(id: id))
    }
}
