//
//  GetUserAccountsUseCase.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//

import Foundation

public protocol GetUserAccountsUseCase: Sendable {
    func callAsFunction(userId: UUID) async throws -> [BankAccount]
}

public struct GetUserAccountsUseCaseImpl: GetUserAccountsUseCase {
    private let repo: EmployeeAccountsRepository
    public init(repo: EmployeeAccountsRepository) { self.repo = repo }

    public func callAsFunction(userId: UUID) async throws -> [BankAccount] {
        let dtos = try await repo.accounts(for: userId)
        return dtos.map(BankAccountMapper.toDomain)
    }
}
