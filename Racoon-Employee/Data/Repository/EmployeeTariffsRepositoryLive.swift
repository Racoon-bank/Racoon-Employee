//
//  EmployeeTariffsRepositoryLive.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//

import Foundation

public final class EmployeeTariffsRepositoryLive: EmployeeTariffsRepository {
    private let client: HTTPClient
    public init(client: HTTPClient) { self.client = client }

    public func tariffs() async throws -> [CreditTariffDto] {
        try await client.send(CreditRouter.tariffs, as: [CreditTariffDto].self)
    }

    public func getTariff(id: Int64) async throws -> CreditTariffDto {
        try await client.send(CreditRouter.tariff(id: id), as: CreditTariffDto.self)
    }

    public func createTariff(name: String, interestRate: Double, dueDate: Date, isActive: Bool?) async throws -> CreditTariffDto {
        try await client.send(
            CreditRouter.createTariff(name: name, interestRate: interestRate, dueDate: dueDate, isActive: isActive),
            as: CreditTariffDto.self
        )
    }

    public func deleteTariff(id: Int64) async throws {
        try await client.sendNoResponse(CreditRouter.deleteTariff(id: id))
    }
}
