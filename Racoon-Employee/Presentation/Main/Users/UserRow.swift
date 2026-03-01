//
//  UserRow.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


import SwiftUI

struct UserRow: View {
    let user: User

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(user.username)
                    .font(.headline)
                Spacer()
                Text(user.isBlocked ? "Blocked" : "Active")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.thinMaterial)
                    .clipShape(Capsule())
            }

            HStack(spacing: 10) {
                if let email = user.email, !email.isEmpty {
                    Text(email)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                } else {
                    Text("No email")
                        .foregroundStyle(.secondary)
                }

                Spacer()

            }

            Text(user.id.uuidString)
                .font(.caption2)
                .foregroundStyle(.tertiary)
                .lineLimit(1)
        }
        .padding(.vertical, 6)
    }
}
