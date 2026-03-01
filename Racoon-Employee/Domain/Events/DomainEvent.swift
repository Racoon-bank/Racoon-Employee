//
//  DomainEvent.swift
//  Racoon-client
//
//  Created by dark type on 26.02.2026.
//

import Foundation

public enum DomainEvent: Sendable {
    case userCreated(id: UUID)
    case userBanned(id: UUID)
    case employeeCreated(id: UUID)

    case tariffCreated(id: Int64)
    case tariffDeleted(id: Int64)
}
