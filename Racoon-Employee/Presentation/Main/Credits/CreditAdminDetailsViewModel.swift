//
//  CreditAdminDetailsViewModel.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


import Combine

@MainActor
final class CreditAdminDetailsViewModel: ObservableObject {
    @Published private(set) var state: AsyncViewState = .idle

    @Published private(set) var credit: Credit?
    @Published private(set) var statistics: CreditStatistics?
    @Published private(set) var schedule: [PaymentScheduleItem] = []
    @Published private(set) var payments: [CreditPayment] = []

    private let creditId: Int64
    private let getCredit: GetCreditUseCase
    private let getStatistics: GetCreditStatisticsUseCase
    private let getSchedule: GetCreditScheduleUseCase
    private let getPayments: GetCreditPaymentsUseCase

    init(
        creditId: Int64,
        getCredit: GetCreditUseCase,
        getStatistics: GetCreditStatisticsUseCase,
        getSchedule: GetCreditScheduleUseCase,
        getPayments: GetCreditPaymentsUseCase
    ) {
        self.creditId = creditId
        self.getCredit = getCredit
        self.getStatistics = getStatistics
        self.getSchedule = getSchedule
        self.getPayments = getPayments
    }

    func load() async {
        state = .loading
        do {
            try await reload()
            state = .idle
        } catch {
            state = .error(message: "Failed to load credit details.")
        }
    }

    func refresh() async {
        do {
            try await reload()
        } catch {
            state = .error(message: "Failed to refresh.")
        }
    }

    func clearError() {
        if case .error = state { state = .idle }
    }

    private func reload() async throws {
        async let creditTask: Credit = getCredit(id: creditId)
        async let statsTask: CreditStatistics = getStatistics(creditId: creditId)
        async let scheduleTask: [PaymentScheduleItem] = getSchedule(creditId: creditId)
        async let paymentsTask: [CreditPayment] = getPayments(creditId: creditId)

        let (c, s, sch, p) = try await (creditTask, statsTask, scheduleTask, paymentsTask)
        credit = c
        statistics = s
        schedule = sch
        payments = p
    }
}
