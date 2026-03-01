//
//  CreateTariffInput.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


import SwiftUI

struct CreateTariffInput: Sendable {
    let name: String
    let interestRate: Decimal
    let dueDate: Date
    let isActive: Bool
}


