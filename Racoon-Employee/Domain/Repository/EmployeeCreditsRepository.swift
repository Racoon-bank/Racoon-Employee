//
//  EmployeeCreditsRepository.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


public protocol EmployeeCreditsRepository: Sendable {
    func allCredits() async throws -> [CreditDto]
    func getCredit(id: Int64) async throws -> CreditDto
    func statistics(creditId: Int64) async throws -> CreditStatisticsDto
    func schedule(creditId: Int64) async throws -> [PaymentScheduleDto]
    func payments(creditId: Int64) async throws -> [CreditPaymentDto]
}