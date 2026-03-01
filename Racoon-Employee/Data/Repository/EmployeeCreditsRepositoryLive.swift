//
//  EmployeeCreditsRepositoryLive.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


public final class EmployeeCreditsRepositoryLive: EmployeeCreditsRepository {
    private let client: HTTPClient
    public init(client: HTTPClient) { self.client = client }

    public func allCredits() async throws -> [CreditDto] {
        try await client.send(CreditRouter.allCredits, as: [CreditDto].self)
    }

    public func getCredit(id: Int64) async throws -> CreditDto {
        try await client.send(CreditRouter.credit(id: id), as: CreditDto.self)
    }

    public func statistics(creditId: Int64) async throws -> CreditStatisticsDto {
        try await client.send(CreditRouter.statistics(creditId: creditId), as: CreditStatisticsDto.self)
    }

    public func schedule(creditId: Int64) async throws -> [PaymentScheduleDto] {
        try await client.send(CreditRouter.schedule(creditId: creditId), as: [PaymentScheduleDto].self)
    }

    public func payments(creditId: Int64) async throws -> [CreditPaymentDto] {
        try await client.send(CreditRouter.payments(creditId: creditId), as: [CreditPaymentDto].self)
    }
}