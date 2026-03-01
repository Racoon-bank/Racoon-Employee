//
//  EmployeeTariffsRepository.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//

import Foundation

public protocol EmployeeTariffsRepository: Sendable {
    func tariffs() async throws -> [CreditTariffDto]
    func getTariff(id: Int64) async throws -> CreditTariffDto
    func createTariff(name: String, interestRate: Double, dueDate: Date, isActive: Bool?) async throws -> CreditTariffDto
    func deleteTariff(id: Int64) async throws
}
