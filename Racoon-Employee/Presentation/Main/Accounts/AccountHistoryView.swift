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
                LabeledContent("Number", value: account.accountNumber ?? "—")
                LabeledContent("Balance", value: MoneyFormatter.shared.string(from: account.balance))
            }

            Section("Owner") {
                if let user = viewModel.user {
                    LabeledContent("Name", value: user.username)
                    if let email = user.email, !email.isEmpty {
                        LabeledContent("Email", value: email)
                    }
                    LabeledContent("User ID", value: user.id.uuidString)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    Text("User info is unavailable.")
                        .foregroundStyle(.secondary)
                }
            }

            Section("History") {
                if viewModel.operations.isEmpty {
                    Text("No operations.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(viewModel.operations) { op in
                        AccountOperationRow(op: op)
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


