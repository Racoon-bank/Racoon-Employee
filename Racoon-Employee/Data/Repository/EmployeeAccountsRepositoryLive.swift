//
//  EmployeeAccountsRepositoryLive.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//

import Foundation

public final class EmployeeAccountsRepositoryLive: EmployeeAccountsRepository {
    private let client: HTTPClient
    public init(client: HTTPClient) { self.client = client }

    public func allAccounts() async throws -> [BankAccountDto] {
        try await client.send(CoreRouter.allAccounts, as: [BankAccountDto].self)
    }

    public func accounts(for userId: UUID) async throws -> [BankAccountDto] {
        try await client.send(CoreRouter.userAccounts(userId: userId), as: [BankAccountDto].self)
    }

    public func history(accountId: UUID) async throws -> [BankAccountOperationDto] {
        try await client.send(CoreRouter.accountHistory(accountId: accountId), as: [BankAccountOperationDto].self)
    }
}
