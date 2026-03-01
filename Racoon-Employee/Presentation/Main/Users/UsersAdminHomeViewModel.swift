//
//  UsersAdminHomeViewModel.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


import Combine
import SwiftUI
import Foundation


@MainActor
final class UsersAdminHomeViewModel: ObservableObject {
   

    enum StatusFilter: String, CaseIterable, Identifiable {
        case all = "All"
        case active = "Active"
        case blocked = "Blocked"

        var id: String { rawValue }
    }

    @Published private(set) var state: AsyncViewState = .idle
    @Published private(set) var users: [User] = []

    @Published var searchText: String = ""
    @Published var statusFilter: StatusFilter = .all

    @Published var showCreateUserSheet = false
    @Published var showCreateEmployeeSheet = false

    private let getAllUsers: GetAllUsersUseCase
    private let createUser: CreateUserUseCase
    private let createEmployee: CreateEmployeeUseCase
    private let banUser: BanUserUseCase

    init(
        getAllUsers: GetAllUsersUseCase,
        createUser: CreateUserUseCase,
        createEmployee: CreateEmployeeUseCase,
        banUser: BanUserUseCase
    ) {
        self.getAllUsers = getAllUsers
        self.createUser = createUser
        self.createEmployee = createEmployee
        self.banUser = banUser
    }

    func load() async {
        state = .loading
        do {
            users = try await getAllUsers()
            state = .idle
        } catch {
            state = .error(message: "Failed to load users.")
        }
    }

    func refresh() async {
        do {
            users = try await getAllUsers()
        } catch {
            state = .error(message: "Failed to refresh.")
        }
    }

    func createClient(username: String, email: String?, password: String) async {
        state = .loading
        do {
            _ = try await createUser(username: username, email: email, password: password)
            users = try await getAllUsers()
            state = .idle
        } catch {
            state = .error(message: "Failed to create client.")
        }
    }

    func createStaff(username: String, email: String?, password: String) async {
        state = .loading
        do {
            _ = try await createEmployee(username: username, email: email, password: password)
            users = try await getAllUsers()
            state = .idle
        } catch {
            state = .error(message: "Failed to create employee.")
        }
    }

    func setBlocked(_ blocked: Bool, userId: UUID) async {
        state = .loading
        do {
            try await banUser(id: userId)

            users = users.map { u in
                guard u.id == userId else { return u }
                return User(
                    id: u.id,
                    username: u.username,
                    email: u.email,
                    role: u.role,
                    isBlocked: blocked,
                )
            }
            state = .idle
        } catch {
            state = .error(message: blocked ? "Failed to block user." : "Failed to unblock user.")
        }
    }

    func clearError() {
        if case .error = state { state = .idle }
    }

    var filteredUsers: [User] {
        var list = users


        switch statusFilter {
        case .all: break
        case .active: list = list.filter { !$0.isBlocked }
        case .blocked: list = list.filter { $0.isBlocked }
        }

        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return list }

        return list.filter { u in
            u.username.localizedCaseInsensitiveContains(q) ||
            (u.email?.localizedCaseInsensitiveContains(q) ?? false) ||
            u.id.uuidString.localizedCaseInsensitiveContains(q)
        }
    }
}
