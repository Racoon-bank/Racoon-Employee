//
//  AuthFlowView.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


import SwiftUI

struct AuthFlowView: View {
    @Environment(\.appContainer) private var container
    @EnvironmentObject private var appState: AppState

    var body: some View {
        NavigationStack {
            let factory = ViewModelFactory(container: container)
            LoginView(viewModel: factory.makeLoginViewModel(appState: appState))
        }
    }
}