//
//  CreateTariffUseCase.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//

import Foundation

public protocol CreateTariffUseCase: Sendable {
    func callAsFunction(name: String, interestRate: Decimal, dueDate: Date, isActive: Bool?) async throws -> CreditTariff
}

public struct CreateTariffUseCaseImpl: CreateTariffUseCase {
    private let repo: EmployeeTariffsRepository
    private let events: DomainEventBus?

    public init(repo: EmployeeTariffsRepository, events: DomainEventBus? = nil) {
        self.repo = repo
        self.events = events
    }

    public func callAsFunction(name: String, interestRate: Decimal, dueDate: Date, isActive: Bool?) async throws -> CreditTariff {
        let dto = try await repo.createTariff(
            name: name,
            interestRate: NSDecimalNumber(decimal: interestRate).doubleValue,
            dueDate: dueDate,
            isActive: isActive
        )
        let tariff = CreditTariffMapper.toDomain(dto)
        await events?.publish(.tariffCreated(id: tariff.id))
        return tariff
    }
}
