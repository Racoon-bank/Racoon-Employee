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
                Text(operationTitle(for: op.type))
                    .font(.headline)
                Spacer()
                Text(NSDecimalNumber(decimal: op.amount).stringValue)
                    .monospacedDigit()
                    .foregroundStyle(amountColor(for: op.type))
            }
            Text(op.createdAt.formatted(date: .abbreviated, time: .shortened))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 6)
    }
    
    private func operationTitle(for type: BankOperationType) -> String {
        switch type {
        case .deposit: return "Deposit"
        case .withdraw: return "Withdraw"
        case .creditIssued: return "Credit Issued"
        case .creditPayment: return "Credit Payment"
        case .unknown: return "Transfer / Unknown"
        }
    }
    
    private func amountColor(for type: BankOperationType) -> Color {
        switch type {
        case .deposit, .creditIssued: return .green
        case .withdraw, .creditPayment: return .primary
        case .unknown: return .primary
        }
    }
}
