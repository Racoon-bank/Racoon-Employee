//
//  TariffsAdminHomeView.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


import SwiftUI

struct TariffsAdminHomeView: View {
    @StateObject private var viewModel: TariffsAdminHomeViewModel
    @State private var confirmDelete: CreditTariff?

    init(viewModel: TariffsAdminHomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        List {
            if viewModel.filteredTariffs.isEmpty {
                Text("No tariffs.")
                    .foregroundStyle(.secondary)
            } else {
                Section {
                    ForEach(viewModel.filteredTariffs) { t in
                        TariffRow(tariff: t)
                            .contentShape(Rectangle())
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    confirmDelete = t
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                }
            }
        }
        .navigationTitle("Tariffs")
        .searchable(text: $viewModel.searchText, prompt: "Search tariffs")
        .task { await viewModel.load() }
        .refreshable { await viewModel.refresh() }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.showCreateSheet = true
                } label: {
                    Image(systemName: "plus")
                }
                .disabled(viewModel.state.isLoading)
            }

            ToolbarItem(placement: .topBarTrailing) {
                if viewModel.state.isLoading { ProgressView().controlSize(.small) }
            }
        }
        .sheet(isPresented: $viewModel.showCreateSheet) {
            CreateTariffSheet { input in
                Task {
                    await viewModel.create(
                        name: input.name,
                        interestRate: input.interestRate*100,
                        dueDate: input.dueDate,
                        isActive: input.isActive
                    )
                }
            }
        }
        .confirmationDialog(
            "Delete tariff?",
            isPresented: Binding(
                get: { confirmDelete != nil },
                set: { if !$0 { confirmDelete = nil } }
            ),
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                guard let t = confirmDelete else { return }
                Task { await viewModel.delete(id: t.id) }
                confirmDelete = nil
            }
            Button("Cancel", role: .cancel) { confirmDelete = nil }
        } message: {
            Text("This action cannot be undone.")
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


