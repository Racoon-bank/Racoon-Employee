//
//  CreditDto.swift
//  Racoon-client
//
//  Created by dark type on 26.02.2026.
//

import Foundation

public struct CreditDto: Decodable, Sendable {
    public let id: Int64
    public let ownerId: String

    public let tariffId: Int64
    public let tariffName: String

    public let interestRate: Double

    public let amount: Double
    public let remainingAmount: Double
    public let monthlyPayment: Double

    public let durationMonths: Int
    public let remainingMonths: Int

    public let accumulatedPenalty: Double
    public let overdueDays: Int

    public let status: String

    public let issueDate: Date
    public let nextPaymentDate: Date?

    public let createdAt: Date
    public let updatedAt: Date?
}

public struct CreditApplicationDto: Decodable, Sendable {
    public let id: Int64
    public let ownerId: String
    public let bankAccountId: String?
    public let tariffId: Int64?
    public let tariffName: String?
    public let currency: String?
    public let amount: Double
    public let durationMonths: Int?
    public let creditRating: Int?
    public let status: String?
    public let employeeComment: String?
    public let reviewedBy: String?
    public let reviewedAt: Date?
    public let createdAt: Date?
    public let updatedAt: Date?
}

public struct CreditRatingDto: Decodable, Sendable {
    public let userId: String
    public let score: Int
    public let ratingLevel: String?
    public let totalCredits: Int?
    public let activeCredits: Int?
    public let completedCreditsWithoutOverdues: Int?
    public let currentOverduePayments: Int?
    public let historicalOverduePayments: Int?
    public let maxCurrentOverdueDays: Int?
    public let onTimePaymentRatio: Double?
    public let totalRemainingDebt: Double?
    public let calculatedAt: Date?
}
