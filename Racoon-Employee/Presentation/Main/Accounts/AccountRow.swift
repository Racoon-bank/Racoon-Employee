import SwiftUI
import SwiftUI

struct AccountRow: View {
    let account: BankAccount

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(account.accountNumber ?? "Error")
                    .font(.headline)
                    .lineLimit(1)
                Spacer()
                Text(MoneyFormatter.shared.string(from: account.balance))
                    .monospacedDigit()
                    .foregroundStyle(account.balance < 0 ? .red : .primary)
            }

            HStack(spacing: 8) {
                Text("User: \(account.userId.uuidString.prefix(8))…")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(account.createdAt.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 6)
    }
}