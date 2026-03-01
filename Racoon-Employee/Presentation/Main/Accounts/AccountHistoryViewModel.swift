//
//  AccountHistoryViewModel.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


import Combine
import Foundation

import Foundation

@MainActor
final class AccountHistoryViewModel: ObservableObject {
    @Published private(set) var state: AsyncViewState = .idle
    @Published private(set) var operations: [BankOperation] = []

    @Published private(set) var user: User?

    private let accountId: UUID
    private let userId: UUID

    private let getHistory: GetAccountHistoryUseCase
    private let getAllUsers: GetAllUsersUseCase

    init(
        accountId: UUID,
        userId: UUID,
        getHistory: GetAccountHistoryUseCase,
        getAllUsers: GetAllUsersUseCase
    ) {
        self.accountId = accountId
        self.userId = userId
        self.getHistory = getHistory
        self.getAllUsers = getAllUsers
    }

    func load() async {
        state = .loading
        do {
            async let opsTask: [BankOperation] = getHistory(accountId: accountId)
            async let usersTask: [User] = getAllUsers()

            let (ops, users) = try await (opsTask, usersTask)

            self.operations = ops
            self.user = users.first(where: { $0.id == userId })

            state = .idle
        } catch {
            state = .error(message: "Failed to load history.")
        }
    }

    func refresh() async {
        do {
            async let opsTask: [BankOperation] = getHistory(accountId: accountId)
            async let usersTask: [User] = getAllUsers()

            let (ops, users) = try await (opsTask, usersTask)

            self.operations = ops
            self.user = users.first(where: { $0.id == userId })
        } catch {
            state = .error(message: "Failed to refresh.")
        }
    }

    func clearError() {
        if case .error = state { state = .idle }
    }
}
