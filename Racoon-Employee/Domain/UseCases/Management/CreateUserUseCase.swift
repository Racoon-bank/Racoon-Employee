//
//  CreateUserUseCase.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


public protocol CreateUserUseCase: Sendable {
    func callAsFunction(username: String, email: String?, password: String) async throws -> User
}

public struct CreateUserUseCaseImpl: CreateUserUseCase {
    private let repo: EmployeeUsersRepository
    private let events: DomainEventBus?

    public init(repo: EmployeeUsersRepository, events: DomainEventBus? = nil) {
        self.repo = repo
        self.events = events
    }

    public func callAsFunction(username: String, email: String?, password: String) async throws -> User {
        let dto = try await repo.createUser(username: username, email: email, password: password)
        let user = UserMapper.toDomain(dto)
        await events?.publish(.userCreated(id: user.id))
        return user
    }
}