//
//  AccountHistoryView.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


import SwiftUI

struct AccountHistoryView: View {
    @StateObject private var viewModel: AccountHistoryViewModel
    let account: BankAccount

    init(viewModel: AccountHistoryViewModel, account: BankAccount) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.account = account
    }

    var body: some View {
        List {
            Section("Account") {
                LabeledContent("Number", value: account.accountNumber ?? "Error")
                LabeledContent("Balance", value: MoneyFormatter.shared.string(from: account.balance))
                LabeledContent("User", value: account.userId.uuidString)
            }

            Section("History") {
                if viewModel.operations.isEmpty {
                    Text("No operations.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(viewModel.operations) { op in
                        OperationRow(op: op)
                    }
                }
            }
        }
        .navigationTitle("History")
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
}

private struct OperationRow: View {
    let op: BankOperation

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(op.type.title)
                    .font(.headline)
                Spacer()
                Text(MoneyFormatter.shared.string(from: op.amount))
                    .monospacedDigit()
                    .foregroundStyle(op.type.isNegative ? .red : .primary)
            }
            Text(op.createdAt.formatted(date: .abbreviated, time: .shortened))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 6)
    }
}
