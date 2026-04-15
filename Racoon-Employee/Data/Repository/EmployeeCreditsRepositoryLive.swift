//
//  EmployeeCreditsRepositoryLive.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//

import Foundation

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
    
    public func pendingApplications() async throws -> [CreditApplicationDto] {
        try await client.send(CreditRouter.pendingApplications, as: [CreditApplicationDto].self)
    }
    public func approveApplication(id: Int64, comment: String?) async throws {
        try await client.sendNoResponse(CreditRouter.approveApplication(id: id, comment: comment))
    }
    public func rejectApplication(id: Int64, comment: String?) async throws {
        try await client.sendNoResponse(CreditRouter.rejectApplication(id: id, comment: comment))
    }
    public func userRating(userId: UUID) async throws -> CreditRatingDto {
        try await client.send(CreditRouter.userRating(userId: userId), as: CreditRatingDto.self)
    }
}
