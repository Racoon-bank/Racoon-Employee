//
//  AccountHistoryViewModel.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


import Combine
import Foundation

@MainActor
final class AccountHistoryViewModel: ObservableObject {
    @Published private(set) var state: AsyncViewState = .idle
    @Published private(set) var operations: [BankOperation] = []

    private let accountId: UUID
    private let getHistory: GetAccountHistoryUseCase

    init(accountId: UUID, getHistory: GetAccountHistoryUseCase) {
        self.accountId = accountId
        self.getHistory = getHistory
    }

    func load() async {
        state = .loading
        do {
            operations = try await getHistory(accountId: accountId)
            state = .idle
        } catch {
            state = .error(message: "Failed to load history.")
        }
    }

    func refresh() async {
        do {
            operations = try await getHistory(accountId: accountId)
        } catch {
            state = .error(message: "Failed to refresh.")
        }
    }

    func clearError() {
        if case .error = state { state = .idle }
    }
}
