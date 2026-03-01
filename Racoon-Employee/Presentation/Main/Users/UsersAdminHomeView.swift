//
//  UsersAdminHomeView.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


import SwiftUI

struct UsersAdminHomeView: View {
    @StateObject private var viewModel: UsersAdminHomeViewModel
    @State private var confirmToggle: ToggleBlockIntent?

    init(viewModel: UsersAdminHomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 10) {
                    Picker("Status", selection: $viewModel.statusFilter) {
                        ForEach(UsersAdminHomeViewModel.StatusFilter.allCases) { f in
                            Text(f.rawValue).tag(f)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .padding(.vertical, 6)
            }

            if viewModel.filteredUsers.isEmpty {
                Text("No users found.")
                    .foregroundStyle(.secondary)
            } else {
                Section {
                    ForEach(viewModel.filteredUsers) { u in
                        UserRow(user: u)
                            .contextMenu {
                                Button {
                                    confirmToggle = .init(userId: u.id, newBlockedValue: !u.isBlocked, username: u.username)
                                } label: {
                                    Label(u.isBlocked ? "Unblock" : "Block", systemImage: u.isBlocked ? "lock.open" : "lock")
                                }
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: u.isBlocked ? .none : .destructive) {
                                    confirmToggle = .init(userId: u.id, newBlockedValue: !u.isBlocked, username: u.username)
                                } label: {
                                    Label(u.isBlocked ? "Unblock" : "Block", systemImage: u.isBlocked ? "lock.open" : "lock")
                                }
                            }
                    }
                }
            }
        }
        .navigationTitle("Users")
        .searchable(text: $viewModel.searchText, prompt: "Search by name, email, id")
        .task { await viewModel.load() }
        .refreshable { await viewModel.refresh() }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button {
                        viewModel.showCreateUserSheet = true
                    } label: {
                        Label("Create client", systemImage: "person.badge.plus")
                    }

                    Button {
                        viewModel.showCreateEmployeeSheet = true
                    } label: {
                        Label("Create employee", systemImage: "person.2.badge.plus")
                    }
                } label: {
                    Image(systemName: "plus")
                }
                .disabled(viewModel.state.isLoading)
            }

            ToolbarItem(placement: .topBarTrailing) {
                if viewModel.state.isLoading { ProgressView().controlSize(.small) }
            }
        }
        .sheet(isPresented: $viewModel.showCreateUserSheet) {
            CreateUserSheet(title: "New client", confirmTitle: "Create") { input in
                Task {
                    await viewModel.createClient(username: input.username, email: input.email, password: input.password)
                }
            }
        }
        .sheet(isPresented: $viewModel.showCreateEmployeeSheet) {
            CreateUserSheet(title: "New employee", confirmTitle: "Create") { input in
                Task {
                    await viewModel.createStaff(username: input.username, email: input.email, password: input.password)
                }
            }
        }
        .confirmationDialog(
            "Change user status?",
            isPresented: Binding(
                get: { confirmToggle != nil },
                set: { if !$0 { confirmToggle = nil } }
            ),
            titleVisibility: .visible
        ) {
            if let intent = confirmToggle {
                Button(intent.newBlockedValue ? "Block" : "Unblock", role: intent.newBlockedValue ? .destructive : .none) {
                    Task { await viewModel.setBlocked(intent.newBlockedValue, userId: intent.userId) }
                    confirmToggle = nil
                }
            }
            Button("Cancel", role: .cancel) { confirmToggle = nil }
        } message: {
            if let intent = confirmToggle {
                Text("\(intent.newBlockedValue ? "Block" : "Unblock") “\(intent.username)”?")
            }
        }
        .alert("Error", isPresented: Binding(
            get: { viewModel.state.errorMessage != nil },
            set: { isPresented in if !isPresented { viewModel.clearError() } }
        )) {
            Button("OK", role: .cancel) { viewModel.clearError() }
        } message: {
            Text(viewModel.state.errorMessage ?? "")
        }
    }
}




