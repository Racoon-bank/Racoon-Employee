//
//  ToggleBlockIntent.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


import SwiftUI
import Foundation

struct ToggleBlockIntent: Identifiable, Sendable {
    let id = UUID()
    let userId: UUID
    let newBlockedValue: Bool
    let username: String
}
