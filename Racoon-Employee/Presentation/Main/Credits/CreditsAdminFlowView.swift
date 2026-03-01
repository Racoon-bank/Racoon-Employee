//
//  CreditsAdminFlowView.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


import SwiftUI

struct CreditsAdminFlowView: View {
    @Environment(\.appContainer) private var container
    @EnvironmentObject private var appState: AppState

    var body: some View {
        NavigationStack {
            let factory = ViewModelFactory(container: container)
            CreditsAdminHomeView(viewModel: factory.makeCreditsAdminHomeViewModel())
        }
    }
}