//
//  GetCreditScheduleUseCase.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


public protocol GetCreditScheduleUseCase: Sendable {
    func callAsFunction(creditId: Int64) async throws -> [PaymentScheduleItem]
}

public struct GetCreditScheduleUseCaseImpl: GetCreditScheduleUseCase {
    private let repo: EmployeeCreditsRepository
    public init(repo: EmployeeCreditsRepository) { self.repo = repo }

    public func callAsFunction(creditId: Int64) async throws -> [PaymentScheduleItem] {
        let dtos = try await repo.schedule(creditId: creditId)
        return dtos.map(PaymentScheduleMapper.toDomain)
    }
}