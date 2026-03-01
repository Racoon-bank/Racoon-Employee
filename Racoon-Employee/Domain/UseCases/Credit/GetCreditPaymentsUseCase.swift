//
//  GetCreditPaymentsUseCase.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


public protocol GetCreditPaymentsUseCase: Sendable {
    func callAsFunction(creditId: Int64) async throws -> [CreditPayment]
}

public struct GetCreditPaymentsUseCaseImpl: GetCreditPaymentsUseCase {
    private let repo: EmployeeCreditsRepository
    public init(repo: EmployeeCreditsRepository) { self.repo = repo }

    public func callAsFunction(creditId: Int64) async throws -> [CreditPayment] {
        let dtos = try await repo.payments(creditId: creditId)
        return dtos.map(CreditMapper.toDomain)
    }
}