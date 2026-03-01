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
                Text(account.accountNumber ?? "—")
                    .font(.headline)
                    .lineLimit(1)
                Spacer()
                Text(MoneyFormatter.shared.string(from: account.balance))
                    .monospacedDigit()
                    .foregroundStyle(account.balance < 0 ? .red : .primary)
            }

            HStack(spacing: 8) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(userTitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                    if let userSubtitle, !userSubtitle.isEmpty {
                        Text(userSubtitle)
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                            .lineLimit(1)
                    }
                }

                Spacer()

                Text(account.createdAt.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 6)
    }
}
