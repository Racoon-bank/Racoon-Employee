//
//  CreateEmployeeUseCase.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


public protocol CreateEmployeeUseCase: Sendable {
    func callAsFunction(username: String, email: String?, password: String) async throws -> User
}

public struct CreateEmployeeUseCaseImpl: CreateEmployeeUseCase {
    private let repo: EmployeeUsersRepository
    private let events: DomainEventBus?

    public init(repo: EmployeeUsersRepository, events: DomainEventBus? = nil) {
        self.repo = repo
        self.events = events
    }

    public func callAsFunction(username: String, email: String?, password: String) async throws -> User {
        let dto = try await repo.createEmployee(username: username, email: email, password: password)
        let emp = UserMapper.toDomain(dto)
        await events?.publish(.employeeCreated(id: emp.id))
        return emp
    }
}