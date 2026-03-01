//
//  EmployeeAccountsRepository.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//

import Foundation

public protocol EmployeeAccountsRepository: Sendable {
    func allAccounts() async throws -> [BankAccountDto]
    func accounts(for userId: UUID) async throws -> [BankAccountDto]
    func history(accountId: UUID) async throws -> [BankAccountOperationDto]
}
