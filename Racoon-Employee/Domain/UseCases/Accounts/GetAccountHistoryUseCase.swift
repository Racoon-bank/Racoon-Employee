//
//  GetAccountHistoryUseCase.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//

import Foundation

public protocol GetAccountHistoryUseCase: Sendable {
    func callAsFunction(accountId: UUID) async throws -> [BankOperation]
}

public struct GetAccountHistoryUseCaseImpl: GetAccountHistoryUseCase {
    private let repo: EmployeeAccountsRepository
    public init(repo: EmployeeAccountsRepository) { self.repo = repo }

    public func callAsFunction(accountId: UUID) async throws -> [BankOperation] {
        let dtos = try await repo.history(accountId: accountId)
        return dtos.map(BankAccountMapper.toDomain)
    }
}
