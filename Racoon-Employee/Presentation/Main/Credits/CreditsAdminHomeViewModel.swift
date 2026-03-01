//
//  CreditsAdminHomeViewModel.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


import Combine
import SwiftUI

@MainActor
final class CreditsAdminHomeViewModel: ObservableObject {
    enum Filter: String, CaseIterable, Identifiable {
        case all = "All"
        case active = "Active"
        case overdue = "Overdue"
        case paidOff = "Paid off"

        var id: String { rawValue }
    }

    @Published private(set) var state: AsyncViewState = .idle
    @Published private(set) var credits: [Credit] = []

    @Published var searchText: String = ""
    @Published var filter: Filter = .all

    private let getAllCredits: GetAllCreditsUseCase

    init(getAllCredits: GetAllCreditsUseCase) {
        self.getAllCredits = getAllCredits
    }

    func load() async {
        state = .loading
        do {
            credits = try await getAllCredits()
            state = .idle
        } catch {
            state = .error(message: "Failed to load credits.")
        }
    }

    func refresh() async {
        do {
            credits = try await getAllCredits()
        } catch {
            state = .error(message: "Failed to refresh.")
        }
    }

    func clearError() {
        if case .error = state { state = .idle }
    }

    var filteredCredits: [Credit] {
        var list = credits

        switch filter {
        case .all: break
        case .active:
            list = list.filter { $0.status == .active }
        case .overdue:
            list = list.filter { $0.status == .overdue }
        case .paidOff:
            list = list.filter { $0.status == .paidOff }
        }

        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return list }

        return list.filter { c in
            "\(c.id)".contains(q) ||
            c.tariffName.localizedCaseInsensitiveContains(q) ||
            c.ownerId.uuidString.localizedCaseInsensitiveContains(q)
        }
    }
}
