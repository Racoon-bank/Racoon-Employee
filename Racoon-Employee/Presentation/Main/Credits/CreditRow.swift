//
//  CreditRow.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


import SwiftUI

struct CreditRow: View {
    let credit: Credit

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Credit #\(credit.id)")
                    .font(.headline)
                Spacer()
                Text(credit.status.title)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.thinMaterial)
                    .clipShape(Capsule())
            }

            HStack(spacing: 10) {
                Text(credit.tariffName)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                Spacer()
                Text(MoneyFormatter.shared.string(from: credit.remainingAmount))
                    .monospacedDigit()
            }

            HStack(spacing: 8) {
                Text("Owner: \(credit.ownerId.uuidString.prefix(8))…")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(credit.createdAt.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 6)
    }
}
