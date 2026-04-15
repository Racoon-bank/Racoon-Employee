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
    
    
    @Published private(set) var applications: [CreditApplication] = []
    @Published private(set) var usersById: [UUID: User] = [:]
    @Published private(set) var ratingsByUserId: [UUID: CreditRating] = [:]

    @Published var searchText: String = ""
    @Published var filter: Filter = .all

    private let getAllCredits: GetAllCreditsUseCase
    private let getAllUsers: GetAllUsersUseCase
    private let repo: EmployeeCreditsRepository // Using repo directly for brevity on the new ones

    init(
        getAllCredits: GetAllCreditsUseCase,
        getAllUsers: GetAllUsersUseCase,
        repo: EmployeeCreditsRepository
    ) {
        self.getAllCredits = getAllCredits
        self.getAllUsers = getAllUsers
        self.repo = repo
    }

    func load() async {
        state = .loading
        do {
            try await fetchEverything()
            state = .idle
        } catch {
            state = .error(message: "Failed to load data.")
        }
    }

    func refresh() async {
        do {
            try await fetchEverything()
        } catch {
            state = .error(message: "Failed to refresh.")
        }
    }
    
    private func fetchEverything() async throws {
        async let creditsTask = getAllCredits()
        async let usersTask = getAllUsers()
        async let appsTask = repo.pendingApplications()
        
        let (c, u, appsDtos) = try await (creditsTask, usersTask, appsTask)
        
        self.credits = c
        self.usersById = Dictionary(uniqueKeysWithValues: u.map { ($0.id, $0) })
        self.applications = appsDtos.map(CreditMapper.toDomain)
        
        let ownerIds = Set(self.applications.map { $0.ownerId })
        var newRatings: [UUID: CreditRating] = [:]
        for ownerId in ownerIds {
            if let ratingDto = try? await repo.userRating(userId: ownerId) {
                newRatings[ownerId] = CreditMapper.toDomain(ratingDto)
            }
        }
        self.ratingsByUserId = newRatings
    }

    // 🚨 Application Actions
    func approve(applicationId: Int64, comment: String?) async {
        state = .loading
        do {
            try await repo.approveApplication(id: applicationId, comment: comment)
            try await fetchEverything()
            state = .idle
        } catch {
            state = .error(message: "Failed to approve application.")
        }
    }

    func reject(applicationId: Int64, comment: String?) async {
        state = .loading
        do {
            try await repo.rejectApplication(id: applicationId, comment: comment)
            try await fetchEverything()
            state = .idle
        } catch {
            state = .error(message: "Failed to reject application.")
        }
    }

    func clearError() {
        if case .error = state { state = .idle }
    }

    var filteredCredits: [Credit] {
        var list = credits

        switch filter {
        case .all: break
        case .active: list = list.filter { $0.status == .active }
        case .overdue: list = list.filter { $0.status == .overdue }
        case .paidOff: list = list.filter { $0.status == .paidOff }
        }

        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return list }

        return list.filter { c in
            "\(c.id)".contains(q) ||
            c.tariffName.localizedCaseInsensitiveContains(q) ||
            c.ownerId.uuidString.localizedCaseInsensitiveContains(q) ||
            (usersById[c.ownerId]?.username.localizedCaseInsensitiveContains(q) ?? false)
        }
    }
}
