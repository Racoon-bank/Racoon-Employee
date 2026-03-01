//
//  CoreRouter.swift
//  Racoon-client
//
//  Created by dark type on 26.02.2026.
//

import Foundation

public enum CoreRouter: APIRouter {
    case allAccounts
    case userAccounts(userId: UUID)

    case accountHistory(accountId: UUID)

    public var endpoint: Endpoint {
        switch self {
        case .allAccounts:
            return Endpoint(service: .core, method: .GET, path: "/api/bank-accounts/all")

        case .userAccounts(let userId):
            return Endpoint(service: .core, method: .GET, path: "/api/user/\(userId.uuidString)/bank-accounts")

        case .accountHistory(let accountId):
            return Endpoint(service: .core, method: .GET, path: "/api/bank-accounts/\(accountId.uuidString)/history")
        }
    }
}
