//
//  DeleteTariffUseCase.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


public protocol DeleteTariffUseCase: Sendable {
    func callAsFunction(id: Int64) async throws
}

public struct DeleteTariffUseCaseImpl: DeleteTariffUseCase {
    private let repo: EmployeeTariffsRepository
    private let events: DomainEventBus?

    public init(repo: EmployeeTariffsRepository, events: DomainEventBus? = nil) {
        self.repo = repo
        self.events = events
    }

    public func callAsFunction(id: Int64) async throws {
        try await repo.deleteTariff(id: id)
        await events?.publish(.tariffDeleted(id: id))
    }
}