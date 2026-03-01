//
//  OperationRow.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


import SwiftUI

struct AccountOperationRow: View {
    let op: BankOperation

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(op.type.title)
                    .font(.headline)
                Spacer()
                Text(MoneyFormatter.shared.string(from: op.amount))
                    .monospacedDigit()
                    .foregroundStyle(op.type.isNegative ? .red : .primary)
            }
            Text(op.createdAt.formatted(date: .abbreviated, time: .shortened))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 6)
    }
}
