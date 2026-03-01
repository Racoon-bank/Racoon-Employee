//
//  GetCreditUseCase.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


public protocol GetCreditUseCase: Sendable {
    func callAsFunction(id: Int64) async throws -> Credit
}

public struct GetCreditUseCaseImpl: GetCreditUseCase {
    private let repo: EmployeeCreditsRepository
    public init(repo: EmployeeCreditsRepository) { self.repo = repo }

    public func callAsFunction(id: Int64) async throws -> Credit {
        CreditMapper.toDomain(try await repo.getCredit(id: id))
    }
}