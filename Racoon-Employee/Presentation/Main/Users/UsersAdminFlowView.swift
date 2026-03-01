//
//  UsersAdminFlowView.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


import SwiftUI

struct UsersAdminFlowView: View {
    @Environment(\.appContainer) private var container

    var body: some View {
        NavigationStack {
            let factory = ViewModelFactory(container: container)
            UsersAdminHomeView(viewModel: factory.makeUsersAdminHomeViewModel())
        }
    }
}