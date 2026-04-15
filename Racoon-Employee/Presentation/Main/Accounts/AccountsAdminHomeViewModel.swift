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
    
    private let connectBankHub: ConnectBankHubUseCase
    private let subscribeToAccount: SubscribeToAccountUseCase
    private let eventBus: DomainEventBus

    init(
        getAllAccounts: GetAllAccountsUseCase,
        getAllUsers: GetAllUsersUseCase,
        connectBankHub: ConnectBankHubUseCase,
        subscribeToAccount: SubscribeToAccountUseCase,
        eventBus: DomainEventBus
    ) {
        self.getAllAccounts = getAllAccounts
        self.getAllUsers = getAllUsers
        self.connectBankHub = connectBankHub
        self.subscribeToAccount = subscribeToAccount
        self.eventBus = eventBus
        
        listenForUpdates()
    }

    // MARK: - Event Bus Listener

    private func listenForUpdates() {
        Task {
            for await event in eventBus.events {
                if case .accountUpdated(let updatedAccountId) = event {
                    print("🔄 Admin AccountsList: Refreshing balances due to WS ping for \(updatedAccountId)!")
                    
                    do {
                        try await silentRefresh()
                    } catch {
                        print("⚠️ Admin Failed to silently refresh accounts: \(error)")
                    }
                }
            }
        }
    }

    // MARK: - Load & Refresh

    func load() async {
        guard accounts.isEmpty else {
            await refresh()
            return
        }
        
        state = .loading
        do {
            try await silentRefresh()
            state = .idle
            
            await setupRealTimeUpdates(for: accounts)
        } catch {
            state = .error(message: "Failed to load accounts.")
        }
    }

    func refresh() async {
        do {
            try await silentRefresh()
            await setupRealTimeUpdates(for: accounts)
        } catch {
            state = .error(message: "Failed to refresh.")
        }
    }
    
    private func silentRefresh() async throws {
        async let accountsTask: [BankAccount] = getAllAccounts()
        async let usersTask: [User] = getAllUsers()

        let (accs, users) = try await (accountsTask, usersTask)

        withAnimation {
            self.accounts = accs
            self.usersById = Dictionary(uniqueKeysWithValues: users.map { ($0.id, $0) })
        }
    }

    // MARK: - WebSockets Helper
    
    private func setupRealTimeUpdates(for accounts: [BankAccount]) async {
        await connectBankHub()
        
        for account in accounts {
            do {
                try await subscribeToAccount(accountId: account.id)
                print("✅ Admin Subscribed to updates for account: \(account.id)")
            } catch {
                print("⚠️ Admin Failed to subscribe to account \(account.id): \(error)")
            }
        }
    }

    // MARK: - Utilities

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
