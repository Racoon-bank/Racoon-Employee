//
//  AccountHistoryViewModel.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


import Combine
import Foundation
import SwiftUI

@MainActor
final class AccountHistoryViewModel: ObservableObject {
    @Published private(set) var state: AsyncViewState = .idle
    @Published private(set) var operations: [BankOperation] = []

    @Published private(set) var user: User?
    @Published private(set) var currentBalance: Decimal?

    private let accountId: UUID
    private let userId: UUID

    private let getHistory: GetAccountHistoryUseCase
    private let getAllUsers: GetAllUsersUseCase
    private let getAllAccounts: GetAllAccountsUseCase
    
    private let connectBankHub: ConnectBankHubUseCase
    private let subscribeToAccount: SubscribeToAccountUseCase
    private let eventBus: DomainEventBus

    init(
        accountId: UUID,
        userId: UUID,
        getHistory: GetAccountHistoryUseCase,
        getAllUsers: GetAllUsersUseCase,
        getAllAccounts: GetAllAccountsUseCase,
        connectBankHub: ConnectBankHubUseCase,
        subscribeToAccount: SubscribeToAccountUseCase,
        eventBus: DomainEventBus
    ) {
        self.accountId = accountId
        self.userId = userId
        self.getHistory = getHistory
        self.getAllUsers = getAllUsers
        self.getAllAccounts = getAllAccounts
        self.connectBankHub = connectBankHub
        self.subscribeToAccount = subscribeToAccount
        self.eventBus = eventBus
    }

    // MARK: - Event Bus Listener

    func observeEvents() async {
        print("🎧 Admin Detail: Listening for events for \(accountId)")
        for await event in eventBus.events {
            if case .accountUpdated(let updatedAccountId) = event, updatedAccountId == accountId {
                print("🔄 Admin Detail: Refreshing history & balance due to WS ping!")
                do {
                    try await silentRefresh()
                } catch {
                    print("⚠️ Admin Detail: Failed to refresh on ping: \(error)")
                }
            }
        }
    }

    // MARK: - Load & Refresh

    func load() async {
        state = .loading
        do {
            try await silentRefresh()
            state = .idle
            
            await connectBankHub()
            do {
                try await subscribeToAccount(accountId: accountId)
                print("✅ Admin Detail Subscribed to updates for account: \(accountId)")
            } catch {
                print("⚠️ Admin Detail Failed to subscribe to account \(accountId): \(error)")
            }
        } catch {
            state = .error(message: "Failed to load history.")
        }
    }

    func refresh() async {
        do {
            try await silentRefresh()
        } catch {
            state = .error(message: "Failed to refresh.")
        }
    }
    
    private func silentRefresh() async throws {
        async let opsTask: [BankOperation] = getHistory(accountId: accountId)
        async let usersTask: [User] = getAllUsers()
        async let accsTask: [BankAccount] = getAllAccounts()

        let (ops, users, accs) = try await (opsTask, usersTask, accsTask)

        withAnimation {
            self.operations = ops
            self.user = users.first(where: { $0.id == userId })
            
            if let freshAccount = accs.first(where: { $0.id == accountId }) {
                self.currentBalance = freshAccount.balance
            }
        }
    }

    // MARK: - Utilities

    func clearError() {
        if case .error = state { state = .idle }
    }
}
