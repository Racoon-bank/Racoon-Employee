//
//  GetCreditStatisticsUseCase.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


public protocol GetCreditStatisticsUseCase: Sendable {
    func callAsFunction(creditId: Int64) async throws -> CreditStatistics
}

public struct GetCreditStatisticsUseCaseImpl: GetCreditStatisticsUseCase {
    private let repo: EmployeeCreditsRepository
    public init(repo: EmployeeCreditsRepository) { self.repo = repo }

    public func callAsFunction(creditId: Int64) async throws -> CreditStatistics {
        CreditStatisticsMapper.toDomain(try await repo.statistics(creditId: creditId))
    }
}