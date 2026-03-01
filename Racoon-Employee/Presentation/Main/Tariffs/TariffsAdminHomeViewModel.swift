//
//  TariffsAdminHomeViewModel.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


import Combine
import SwiftUI

@MainActor
final class TariffsAdminHomeViewModel: ObservableObject {
    @Published private(set) var state: AsyncViewState = .idle
    @Published private(set) var tariffs: [CreditTariff] = []

    @Published var searchText: String = ""
    @Published var showCreateSheet: Bool = false

    private let getTariffs: GetTariffsUseCase
    private let createTariff: CreateTariffUseCase
    private let deleteTariff: DeleteTariffUseCase

    init(
        getTariffs: GetTariffsUseCase,
        createTariff: CreateTariffUseCase,
        deleteTariff: DeleteTariffUseCase
    ) {
        self.getTariffs = getTariffs
        self.createTariff = createTariff
        self.deleteTariff = deleteTariff
    }

    func load() async {
        state = .loading
        do {
            tariffs = try await getTariffs()
            state = .idle
        } catch {
            state = .error(message: "Failed to load tariffs.")
        }
    }

    func refresh() async {
        do {
            tariffs = try await getTariffs()
        } catch {
            state = .error(message: "Failed to refresh.")
        }
    }

    func create(name: String, interestRate: Decimal, dueDate: Date, isActive: Bool) async {
        state = .loading
        do {
            _ = try await createTariff(name: name, interestRate: interestRate, dueDate: dueDate, isActive: isActive)
            tariffs = try await getTariffs()
            state = .idle
        } catch {
            state = .error(message: "Failed to create tariff.")
        }
    }

    func delete(id: Int64) async {
        state = .loading
        do {
            try await deleteTariff(id: id)
            tariffs.removeAll { $0.id == id }
            state = .idle
        } catch {
            state = .error(message: "Failed to delete tariff.")
        }
    }

    func clearError() {
        if case .error = state { state = .idle }
    }

    var filteredTariffs: [CreditTariff] {
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return tariffs }

        return tariffs.filter { t in
            t.name.localizedCaseInsensitiveContains(q) ||
            "\(t.id)".contains(q)
        }
    }
}
