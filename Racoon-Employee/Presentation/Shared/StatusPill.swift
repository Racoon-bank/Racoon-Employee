//
//  StatusPill.swift
//  Racoon-Employee
//
//  Created by dark type on 30.03.2026.
//


import SwiftUI

struct StatusPill: View {
    let status: CreditStatus

    var body: some View {
        Text(title)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.2))
            .foregroundStyle(color)
            .clipShape(Capsule())
    }

    private var title: String {
        switch status {
        case .active: return "Active"
        case .paidOff: return "Paid off"
        case .overdue: return "Overdue"
        case .cancelled: return "Cancelled"
        }
    }

    private var color: Color {
        switch status {
        case .active: return .blue
        case .paidOff: return .green
        case .overdue: return .red
        case .cancelled: return .secondary
        }
    }
}
