//
//  AccountRow.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


import SwiftUI

struct AccountRow: View {
    let account: BankAccount
    let userTitle: String
    let userSubtitle: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(account.accountNumber ?? "Account \(account.id.uuidString.prefix(8))")
                    .font(.headline)
            }

            Text(userTitle)
                .font(.subheadline)
            
            if let sub = userSubtitle {
                Text(sub)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            HStack {
                Text("Balance")
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(MoneyFormatter.shared.string(from: account.balance)) \(account.currency.symbol)")
                    .monospacedDigit()
            }
            .font(.subheadline)
            .padding(.top, 4)
        }
        .padding(.vertical, 6)
    }
}
