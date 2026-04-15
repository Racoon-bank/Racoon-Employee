//
//  CreditMapper.swift
//  Racoon-client
//
//  Created by dark type on 27.02.2026.
//


import Foundation

enum CreditMapper {
    static func toDomain(_ dto: CreditDto) -> Credit {
        Credit(
            id: dto.id,
            ownerId: UUID(uuidString: dto.ownerId) ?? UUID(),

            tariffId: dto.tariffId,
            tariffName: dto.tariffName,

            interestRate: Decimal(dto.interestRate),

            amount: Decimal(dto.amount),
            remainingAmount: Decimal(dto.remainingAmount),
            monthlyPayment: Decimal(dto.monthlyPayment),

            durationMonths: dto.durationMonths,
            remainingMonths: dto.remainingMonths,

            accumulatedPenalty: Decimal(dto.accumulatedPenalty),
            overdueDays: dto.overdueDays,

            status: CreditStatus(rawValue: dto.status) ?? .active,

            issueDate: dto.issueDate,
            nextPaymentDate: dto.nextPaymentDate,

            createdAt: dto.createdAt,
            updatedAt: dto.updatedAt
        )
    }

    static func toDomain(_ dto: CreditPaymentDto) -> CreditPayment {
        CreditPayment(
            id: dto.id,
            creditId: dto.creditId,
            amount: Decimal(dto.amount),
            paymentType: CreditPaymentType(rawValue: dto.paymentType.rawValue) ?? .manualRepayment,
            paymentDate: dto.paymentDate,
            createdAt: dto.createdAt
        )
    }
   
        static func toDomain(_ dto: CreditRatingDto) -> CreditRating {
            CreditRating(
                userId: UUID(uuidString: dto.userId) ?? UUID(),
                score: dto.score,
                ratingLevel: dto.ratingLevel ?? "Unknown",
                totalCredits: dto.totalCredits ?? 0,
                activeCredits: dto.activeCredits ?? 0,
                currentOverduePayments: dto.currentOverduePayments ?? 0,
                totalRemainingDebt: Decimal(dto.totalRemainingDebt ?? 0)
            )
        }

        static func toDomain(_ dto: CreditApplicationDto) -> CreditApplication {
            let status = CreditApplicationStatus(rawValue: dto.status ?? "") ?? .pending
            let currency = Currency(rawValue: dto.currency ?? "RUB") ?? .RUB
            
            return CreditApplication(
                id: dto.id,
                ownerId: UUID(uuidString: dto.ownerId) ?? UUID(),
                tariffName: dto.tariffName ?? "Unknown Tariff",
                amount: Decimal(dto.amount),
                currency: currency,
                status: status,
                durationMonths: dto.durationMonths ?? 0,
                creditRatingScore: dto.creditRating,
                employeeComment: dto.employeeComment
            )
        }
    
}
