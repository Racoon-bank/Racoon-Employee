//
//  CreditsAdminHomeView.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


import SwiftUI

struct CreditsAdminHomeView: View {
    @StateObject private var viewModel: CreditsAdminHomeViewModel

    init(viewModel: CreditsAdminHomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        List {
            Section {
                Picker("Filter", selection: $viewModel.filter) {
                    ForEach(CreditsAdminHomeViewModel.Filter.allCases) { f in
                        Text(f.rawValue).tag(f)
                    }
                }
                .pickerStyle(.segmented)
            }

            if viewModel.filteredCredits.isEmpty {
                Text("No credits.")
                    .foregroundStyle(.secondary)
            } else {
                Section {
                    ForEach(viewModel.filteredCredits) { credit in
                        NavigationLink {
                            CreditDetailsDestination(creditId: credit.id)
                        } label: {
                            CreditRow(credit: credit)
                        }
                    }
                }
            }
        }
        .navigationTitle("Credits")
        .searchable(text: $viewModel.searchText, prompt: "Credit ID, owner ID, tariff")
        .task { await viewModel.load() }
        .refreshable { await viewModel.refresh() }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if viewModel.state.isLoading { ProgressView().controlSize(.small) }
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

private struct CreditDetailsDestination: View {
    @Environment(\.appContainer) private var container
    let creditId: Int64

    var body: some View {
        let factory = ViewModelFactory(container: container)
        CreditAdminDetailsView(
            viewModel: factory.makeCreditAdminDetailsViewModel(creditId: creditId),
            creditId: creditId
        )
    }
}

