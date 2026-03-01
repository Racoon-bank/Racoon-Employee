//
//  AccountHistoryDestination.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//

import SwiftUI

struct AccountHistoryDestination: View {
    @Environment(\.appContainer) private var container
    let account: BankAccount

    var body: some View {
        let factory = ViewModelFactory(container: container)
        AccountHistoryView(
            viewModel: factory.makeAccountHistoryViewModel(account: account),
            account: account
        )
    }
}
