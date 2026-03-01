//
//  BanUserUseCase.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//

import Foundation

public protocol BanUserUseCase: Sendable {
    func callAsFunction(id: UUID) async throws
}

public struct BanUserUseCaseImpl: BanUserUseCase {
    private let repo: EmployeeUsersRepository
    private let events: DomainEventBus?

    public init(repo: EmployeeUsersRepository, events: DomainEventBus? = nil) {
        self.repo = repo
        self.events = events
    }

    public func callAsFunction(id: UUID) async throws {
        try await repo.banUser(id: id)
        await events?.publish(.userBanned(id: id))
    }
}
