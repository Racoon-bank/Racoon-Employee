//
//  AccountsAdminHomeView.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


import SwiftUI

struct AccountsAdminHomeView: View {
    @StateObject private var viewModel: AccountsAdminHomeViewModel

    init(viewModel: AccountsAdminHomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        List {
            if viewModel.filteredAccounts.isEmpty {
                emptyState
            } else {
                Section {
                    ForEach(viewModel.filteredAccounts) { a in
                        NavigationLink {
                            AccountHistoryDestination(account: a)
                        } label: {
                            AccountRow(account: a)
                        }
                    }
                }
            }
        }
        .navigationTitle("Accounts")
        .searchable(text: $viewModel.searchText, prompt: "Account number or user id")
        .task { await viewModel.load() }
        .refreshable { await viewModel.refresh() }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if viewModel.state.isLoading { ProgressView().controlSize(.small) }
            }
        }
        .alert("Error", isPresented: Binding(
            get: { viewModel.state.errorMessage != nil },
            set: { isPresented in if !isPresented { viewModel.clearError() } }
        )) {
            Button("OK", role: .cancel) { viewModel.clearError() }
        } message: {
            Text(viewModel.state.errorMessage ?? "")
        }
    }

    private var emptyState: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("No accounts")
                .font(.headline)
            Text("No bank accounts were returned by the server.")
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 10)
    }
}

private struct AccountRow: View {
    let account: BankAccount

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(account.accountNumber ?? "Error")
                    .font(.headline)
                    .lineLimit(1)
                Spacer()
                Text(MoneyFormatter.shared.string(from: account.balance))
                    .monospacedDigit()
                    .foregroundStyle(account.balance < 0 ? .red : .primary)
            }

            HStack(spacing: 8) {
                Text("User: \(account.userId.uuidString.prefix(8))…")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(account.createdAt.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 6)
    }
}
