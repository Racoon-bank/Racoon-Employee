//
//  RegisterUserUseCase.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


public protocol RegisterUserUseCase: Sendable {
    func callAsFunction(username: String, email: String?, password: String) async throws -> User
}

public struct RegisterUserUseCaseImpl: RegisterUserUseCase {
    private let repo: EmployeeUsersRepository

    public init(repo: EmployeeUsersRepository) { self.repo = repo }

    public func callAsFunction(username: String, email: String?, password: String) async throws -> User {
        let dto = try await repo.register(username: username, email: email, password: password)
        return UserMapper.toDomain(dto)
    }
}