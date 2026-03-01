//
//  CreditAdminDetailsView.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


import SwiftUI

struct CreditAdminDetailsView: View {
    @StateObject private var viewModel: CreditAdminDetailsViewModel
    let creditId: Int64

    init(viewModel: CreditAdminDetailsViewModel, creditId: Int64) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.creditId = creditId
    }

    var body: some View {
        List {
            creditSection
            statisticsSection
            scheduleSection
            paymentsSection
        }
        .navigationTitle("Credit #\(creditId)")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if viewModel.state.isLoading { ProgressView().controlSize(.small) }
            }
        }
        .task { await viewModel.load() }
        .refreshable { await viewModel.refresh() }
        .alert("Error", isPresented: Binding(
            get: { viewModel.state.errorMessage != nil },
            set: { isPresented in if !isPresented { viewModel.clearError() } }
        )) {
            Button("OK", role: .cancel) { viewModel.clearError() }
        } message: {
            Text(viewModel.state.errorMessage ?? "")
        }
    }

    private var creditSection: some View {
        Section("Credit") {
            LabeledContent("Status", value: viewModel.credit?.status.title ?? "—")
            LabeledContent("Tariff", value: viewModel.credit?.tariffName ?? "—")
            LabeledContent("Owner", value: viewModel.credit?.ownerId.uuidString ?? "—")

            LabeledContent("Amount", value: money(viewModel.credit?.amount))
            LabeledContent("Remaining", value: money(viewModel.credit?.remainingAmount))

            if let next = viewModel.credit?.nextPaymentDate, viewModel.credit?.status != .paidOff {
                LabeledContent("Next payment", value: next.formatted(date: .abbreviated, time: .shortened))
            }
            if let overdue = viewModel.credit?.overdueDays, overdue > 0 {
                LabeledContent("Overdue days", value: "\(overdue)")
            }
            if let penalty = viewModel.credit?.accumulatedPenalty, penalty > 0 {
                LabeledContent("Penalty", value: MoneyFormatter.shared.string(from: penalty))
            }
        }
    }

    private var statisticsSection: some View {
        Section("Statistics") {
            if let s = viewModel.statistics {
                LabeledContent("Monthly payment", value: MoneyFormatter.shared.string(from: s.monthlyPayment))
                LabeledContent("Total to repay", value: MoneyFormatter.shared.string(from: s.totalToRepay))
                LabeledContent("Total interest", value: MoneyFormatter.shared.string(from: s.totalInterest))
                LabeledContent("Duration (months)", value: "\(s.durationMonths)")
                LabeledContent("Interest rate", value: "\(NSDecimalNumber(decimal: s.interestRate).stringValue)%")
            } else {
                Text("No statistics.")
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var scheduleSection: some View {
        Section("Schedule") {
            if viewModel.schedule.isEmpty {
                Text("No schedule.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(viewModel.schedule) { item in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(item.paymentDate.formatted(date: .abbreviated, time: .shortened))
                            Spacer()
                            Text(MoneyFormatter.shared.string(from: item.totalPayment))
                                .monospacedDigit()
                        }
                        Text(item.paid ? "Paid" : "Planned")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }

    private var paymentsSection: some View {
        Section("Payments") {
            if viewModel.payments.isEmpty {
                Text("No payments.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(viewModel.payments) { p in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(p.paymentType.rawValue)
                                .font(.headline)
                            Spacer()
                            Text(MoneyFormatter.shared.string(from: p.amount))
                                .monospacedDigit()
                        }
                        Text(p.paymentDate.formatted(date: .abbreviated, time: .shortened))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 6)
                }
            }
        }
    }

    private func money(_ value: Decimal?) -> String {
        guard let value else { return "—" }
        return MoneyFormatter.shared.string(from: value)
    }
}
