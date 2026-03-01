//
//  GetAllUsersUseCase.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


public protocol GetAllUsersUseCase: Sendable {
    func callAsFunction() async throws -> [User]
}

public struct GetAllUsersUseCaseImpl: GetAllUsersUseCase {
    private let repo: EmployeeUsersRepository

    public init(repo: EmployeeUsersRepository) { self.repo = repo }

    public func callAsFunction() async throws -> [User] {
        let dtos = try await repo.getAllUsers()
        return dtos.map(UserMapper.toDomain)
    }
}