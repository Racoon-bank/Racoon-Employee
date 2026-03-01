//
//  TariffRow.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


import SwiftUI

struct TariffRow: View {
    let tariff: CreditTariff

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(tariff.name)
                    .font(.headline)
                Spacer()
                Text(tariff.isActive ? "Active" : "Inactive")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.thinMaterial)
                    .clipShape(Capsule())
            }

            HStack(spacing: 12) {
                Text("Rate: \(percent(tariff.interestRate))")
                    .foregroundStyle(.secondary)

                Spacer()

                Text("Due: \(tariff.dueDate.formatted(date: .abbreviated, time: .omitted))")
                    .foregroundStyle(.secondary)
            }
            .font(.subheadline)

            Text("Created: \(tariff.createdAt.formatted(date: .abbreviated, time: .shortened))")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 6)
    }

    private func percent(_ d: Decimal) -> String {
        "\(NSDecimalNumber(decimal: d).stringValue)%"
    }
}