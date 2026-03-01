//
//  GetTariffsUseCase.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


public protocol GetTariffsUseCase: Sendable {
    func callAsFunction() async throws -> [CreditTariff]
}

public struct GetTariffsUseCaseImpl: GetTariffsUseCase {
    private let repo: EmployeeTariffsRepository
    public init(repo: EmployeeTariffsRepository) { self.repo = repo }

    public func callAsFunction() async throws -> [CreditTariff] {
        let dtos = try await repo.tariffs()
        return dtos.map(CreditTariffMapper.toDomain)
    }
}