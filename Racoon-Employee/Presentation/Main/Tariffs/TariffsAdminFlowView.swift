//
//  TariffsAdminFlowView.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


import SwiftUI

struct TariffsAdminFlowView: View {
    @Environment(\.appContainer) private var container

    var body: some View {
        NavigationStack {
            let factory = ViewModelFactory(container: container)
            TariffsAdminHomeView(viewModel: factory.makeTariffsAdminHomeViewModel())
        }
    }
}