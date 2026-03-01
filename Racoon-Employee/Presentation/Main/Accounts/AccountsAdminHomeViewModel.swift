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

    @Published private(set) var usersById: [UUID: User] = [:]

    @Published var searchText: String = ""

    private let getAllAccounts: GetAllAccountsUseCase
    private let getAllUsers: GetAllUsersUseCase

    init(getAllAccounts: GetAllAccountsUseCase, getAllUsers: GetAllUsersUseCase) {
        self.getAllAccounts = getAllAccounts
        self.getAllUsers = getAllUsers
    }

    func load() async {
        state = .loading
        do {
            async let accountsTask: [BankAccount] = getAllAccounts()
            async let usersTask: [User] = getAllUsers()

            let (accs, users) = try await (accountsTask, usersTask)

            self.accounts = accs
            self.usersById = Dictionary(uniqueKeysWithValues: users.map { ($0.id, $0) })

            state = .idle
        } catch {
            state = .error(message: "Failed to load accounts.")
        }
    }

    func refresh() async {
        do {
            async let accountsTask: [BankAccount] = getAllAccounts()
            async let usersTask: [User] = getAllUsers()

            let (accs, users) = try await (accountsTask, usersTask)

            self.accounts = accs
            self.usersById = Dictionary(uniqueKeysWithValues: users.map { ($0.id, $0) })
        } catch {
            state = .error(message: "Failed to refresh.")
        }
    }

    func clearError() {
        if case .error = state { state = .idle }
    }

    func userName(for userId: UUID) -> String {
        usersById[userId]?.username ?? "User \(userId.uuidString.prefix(8))…"
    }

    func userSubtitle(for userId: UUID) -> String? {
        usersById[userId]?.email
    }

    var filteredAccounts: [BankAccount] {
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return accounts }

        return accounts.filter { a in
            (a.accountNumber?.localizedCaseInsensitiveContains(q) ?? false) ||
            a.userId.uuidString.localizedCaseInsensitiveContains(q) ||
            (usersById[a.userId]?.username.localizedCaseInsensitiveContains(q) ?? false) ||
            (usersById[a.userId]?.email?.localizedCaseInsensitiveContains(q) ?? false)
        }
    }
}
