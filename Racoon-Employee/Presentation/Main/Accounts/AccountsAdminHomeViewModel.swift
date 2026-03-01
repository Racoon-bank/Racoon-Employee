//
//  AccountsAdminHomeViewModel.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


import Combine
import SwiftUI

@MainActor
final class AccountsAdminHomeViewModel: ObservableObject {
    @Published private(set) var state: AsyncViewState = .idle
    @Published private(set) var accounts: [BankAccount] = []

    @Published var searchText: String = ""

    private let getAllAccounts: GetAllAccountsUseCase

    init(getAllAccounts: GetAllAccountsUseCase) {
        self.getAllAccounts = getAllAccounts
    }

    func load() async {
        state = .loading
        do {
            accounts = try await getAllAccounts()
            state = .idle
        } catch {
            state = .error(message: "Failed to load accounts.")
        }
    }

    func refresh() async {
        do {
            accounts = try await getAllAccounts()
        } catch {
            state = .error(message: "Failed to refresh.")
        }
    }

    func clearError() {
        if case .error = state { state = .idle }
    }

    var filteredAccounts: [BankAccount] {
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return accounts }

        return accounts.filter { a in
            a.accountNumber?.localizedCaseInsensitiveContains(q) ?? false ||
            a.userId.uuidString.localizedCaseInsensitiveContains(q)
        }
    }
}
