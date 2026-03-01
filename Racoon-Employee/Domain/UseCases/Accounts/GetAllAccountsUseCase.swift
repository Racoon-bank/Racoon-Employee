//
//  GetAllAccountsUseCase.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


public protocol GetAllAccountsUseCase: Sendable {
    func callAsFunction() async throws -> [BankAccount]
}

public struct GetAllAccountsUseCaseImpl: GetAllAccountsUseCase {
    private let repo: EmployeeAccountsRepository

    public init(repo: EmployeeAccountsRepository) { self.repo = repo }

    public func callAsFunction() async throws -> [BankAccount] {
        let dtos = try await repo.allAccounts()
        return dtos.map(BankAccountMapper.toDomain)
    }
}