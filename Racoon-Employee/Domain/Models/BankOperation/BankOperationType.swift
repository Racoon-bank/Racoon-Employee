//
//  BankOperationType.swift
//  Racoon-client
//
//  Created by dark type on 26.02.2026.
//


public enum BankOperationType: Sendable, Equatable {
    case deposit
    case withdraw
    case creditIssued
    case creditPayment
    case unknown(String)
}
public extension BankOperationType {
    var title: String {
        switch self {
        case .deposit:
            return "Deposit"
        case .withdraw:
            return "Withdraw"
        case .creditIssued:
            return "Credit issued"
        case .creditPayment:
            return "Credit payment"
        case .unknown(let raw):
            return raw
        }
    }

    var isNegative: Bool {
        switch self {
        case .withdraw, .creditPayment:
            return true
        case .deposit, .creditIssued:
            return false
        case .unknown:
            return false
        }
    }

    /// Optional: SF Symbol for nicer rows
    var systemImageName: String {
        switch self {
        case .deposit:
            return "arrow.down.circle"
        case .withdraw:
            return "arrow.up.circle"
        case .creditIssued:
            return "plus.circle"
        case .creditPayment:
            return "minus.circle"
        case .unknown:
            return "questionmark.circle"
        }
    }
}
