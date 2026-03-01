//
//  CreditTariffRequestDto.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


import Foundation

public struct CreditTariffRequestDto: Encodable, Sendable {
    public let name: String
    public let interestRate: Double
    public let dueDate: APIDateOnly
    public let isActive: Bool

    public init(
        name: String,
        interestRate: Double,
        dueDate: Date,
        isActive: Bool
    ) {
        self.name = name
        self.interestRate = interestRate
        self.dueDate = APIDateOnly(dueDate)
        self.isActive = isActive
    }
}