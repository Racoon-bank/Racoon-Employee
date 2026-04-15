//
//  Credit.swift
//  Racoon-client
//
//  Created by dark type on 26.02.2026.
//

import Foundation

public struct Credit: Identifiable, Sendable {
    public let id: Int64
    public let ownerId: UUID

    public let tariffId: Int64
    public let tariffName: String
    public let interestRate: Decimal

    public let amount: Decimal
    public let remainingAmount: Decimal
    public let monthlyPayment: Decimal

    public let durationMonths: Int
    public let remainingMonths: Int

    public let accumulatedPenalty: Decimal
    public let overdueDays: Int

    public let status: CreditStatus

    public let issueDate: Date
    public let nextPaymentDate: Date?

    public let createdAt: Date
    public let updatedAt: Date?
}
public enum CreditApplicationStatus: String, Sendable {
    case pending = "PENDING"
    case approved = "APPROVED"
    case rejected = "REJECTED"
}


public struct CreditApplication: Identifiable, Sendable {
    public let id: Int64
    public let ownerId: UUID
    public let tariffName: String
    public let amount: Decimal
    public let currency: Currency
    public let status: CreditApplicationStatus
    public let durationMonths: Int
    public let creditRatingScore: Int?
    public let employeeComment: String?
}

public struct CreditRating: Sendable {
    public let userId: UUID
    public let score: Int
    public let ratingLevel: String
    
    public let totalCredits: Int
    public let activeCredits: Int
    public let currentOverduePayments: Int
    public let totalRemainingDebt: Decimal
}
