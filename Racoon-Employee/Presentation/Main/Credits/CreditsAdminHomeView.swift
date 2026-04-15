//
//  CreditsAdminHomeView.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


import SwiftUI

struct CreditsAdminHomeView: View {
    @StateObject private var viewModel: CreditsAdminHomeViewModel
    
    @State private var decisionApp: CreditApplication?
    @State private var isApproving: Bool = false
    @State private var commentText: String = ""

    init(viewModel: CreditsAdminHomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        List {
            applicationsSection
            filterSection
            creditsSection
        }
        .navigationTitle("Credits")
        .searchable(text: $viewModel.searchText, prompt: "Search credits or users")
        .task { await viewModel.load() }
        .refreshable { await viewModel.refresh() }
        .toolbar { toolbarContent }
        .alert(
            isApproving ? "Approve Application?" : "Reject Application?",
            isPresented: decisionAlertBinding
        ) {
            decisionAlertActions
        } message: {
            Text("Are you sure you want to \(isApproving ? "approve" : "reject") this application?")
        }
        .alert("Error", isPresented: errorAlertBinding) {
            Button("OK", role: .cancel) { viewModel.clearError() }
        } message: {
            Text(viewModel.state.errorMessage ?? "")
        }
    }
}

// MARK: - Subviews
private extension CreditsAdminHomeView {
    
    @ViewBuilder
    var applicationsSection: some View {
        if !viewModel.applications.isEmpty {
            Section("Pending Applications") {
                ForEach(viewModel.applications, id: \.id) { app in
                    applicationRow(for: app)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                isApproving = false
                                decisionApp = app
                            } label: {
                                Label("Reject", systemImage: "xmark")
                            }
                            
                            Button {
                                isApproving = true
                                decisionApp = app
                            } label: {
                                Label("Approve", systemImage: "checkmark")
                            }
                            .tint(.green)
                        }
                }
            }
        }
    }
    
    var filterSection: some View {
        Section {
            Picker("Filter", selection: $viewModel.filter) {
                ForEach(CreditsAdminHomeViewModel.Filter.allCases) { f in
                    Text(f.rawValue).tag(f)
                }
            }
            .pickerStyle(.segmented)
        }
    }
    
    @ViewBuilder
    var creditsSection: some View {
        if viewModel.filteredCredits.isEmpty {
            Text("No credits.")
                .foregroundStyle(.secondary)
        } else {
            Section("Credits") {
                ForEach(viewModel.filteredCredits, id: \.id) { credit in
                    NavigationLink {
                        CreditDetailsDestination(creditId: credit.id)
                    } label: {
                        creditRow(for: credit)
                    }
                }
            }
        }
    }
    
    var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            if viewModel.state.isLoading { ProgressView().controlSize(.small) }
        }
    }
}

// MARK: - Row Views
private extension CreditsAdminHomeView {
    
    func applicationRow(for app: CreditApplication) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(app.tariffName)
                    .font(.headline)
                Spacer()
                Text("\(MoneyFormatter.shared.string(from: app.amount)) \(app.currency.symbol)")
                    .monospacedDigit()
                    .bold()
            }
            
            HStack {
                Text(viewModel.usersById[app.ownerId]?.username ?? "Unknown User")
                    .font(.subheadline)
                
                Spacer()
                
                if let rating = viewModel.ratingsByUserId[app.ownerId] {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                        Text("\(rating.score) (\(rating.ratingLevel))")
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                } else {
                    Text("No Rating")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
    
    func creditRow(for credit: Credit) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(credit.tariffName)
                    .font(.headline)
                Spacer()
                StatusPill(status: credit.status)
            }
            
            Text(viewModel.usersById[credit.ownerId]?.username ?? credit.ownerId.uuidString)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            HStack {
                Text("Remaining:")
                Text("\(MoneyFormatter.shared.string(from: credit.remainingAmount))")
                    .monospacedDigit()
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Alert Helpers
private extension CreditsAdminHomeView {
    
    var decisionAlertBinding: Binding<Bool> {
        Binding(
            get: { decisionApp != nil },
            set: { if !$0 { decisionApp = nil; commentText = "" } }
        )
    }
    
    var errorAlertBinding: Binding<Bool> {
        Binding(
            get: { viewModel.state.errorMessage != nil },
            set: { isPresented in if !isPresented { viewModel.clearError() } }
        )
    }
    
    @ViewBuilder
    var decisionAlertActions: some View {
        TextField("Optional comment", text: $commentText)
        
        Button("Cancel", role: .cancel) {
            decisionApp = nil
            commentText = ""
        }
        
        Button(isApproving ? "Approve" : "Reject", role: isApproving ? .none : .destructive) {
            guard let app = decisionApp else { return }
            let finalComment = commentText.isEmpty ? nil : commentText
            
            Task {
                if isApproving {
                    await viewModel.approve(applicationId: app.id, comment: finalComment)
                } else {
                    await viewModel.reject(applicationId: app.id, comment: finalComment)
                }
            }
        }
    }
}

// MARK: - Destination
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
