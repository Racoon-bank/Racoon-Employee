//
//  CreditRouter.swift
//  Racoon-client
//
//  Created by dark type on 26.02.2026.
//

import Foundation


public struct CreditApplicationDecisionRequestDto: Encodable {
    public let comment: String?
}

public enum CreditRouter: APIRouter {
    case tariffs
    case tariff(id: Int64)
    case createTariff(name: String, interestRate: Double, dueDate: Date, isActive: Bool?)
    case deleteTariff(id: Int64)

    case allCredits
    case credit(id: Int64)
    case statistics(creditId: Int64)
    case schedule(creditId: Int64)
    case payments(creditId: Int64)
    
    case pendingApplications
    case approveApplication(id: Int64, comment: String?)
    case rejectApplication(id: Int64, comment: String?)
    case userRating(userId: UUID)

    public var endpoint: Endpoint {
        switch self {
        case .tariffs: return Endpoint(service: .credit, method: .GET, path: "/api/tariffs")
        case .tariff(let id): return Endpoint(service: .credit, method: .GET, path: "/api/tariffs/\(id)")
        case .createTariff(let name, let rate, let date, let active):
            return Endpoint(service: .credit, method: .POST, path: "/api/employee/tariffs", body: .json(CreditTariffRequestDto(name: name, interestRate: rate, dueDate: date, isActive: active ?? true)))
        case .deleteTariff(let id): return Endpoint(service: .credit, method: .DELETE, path: "/api/employee/tariffs/\(id)")

        case .allCredits: return Endpoint(service: .credit, method: .GET, path: "/api/credits")
        case .credit(let id): return Endpoint(service: .credit, method: .GET, path: "/api/credits/\(id)")
        case .statistics(let id): return Endpoint(service: .credit, method: .GET, path: "/api/credits/\(id)/statistics")
        case .schedule(let id): return Endpoint(service: .credit, method: .GET, path: "/api/credits/\(id)/schedule")
        case .payments(let id): return Endpoint(service: .credit, method: .GET, path: "/api/credits/\(id)/payments")
            
        
        case .pendingApplications:
            return Endpoint(service: .credit, method: .GET, path: "/api/credits/applications/pending")
        case .approveApplication(let id, let comment):
            return Endpoint(service: .credit, method: .POST, path: "/api/credits/applications/\(id)/approve", body: .json(CreditApplicationDecisionRequestDto(comment: comment)))
        case .rejectApplication(let id, let comment):
            return Endpoint(service: .credit, method: .POST, path: "/api/credits/applications/\(id)/reject", body: .json(CreditApplicationDecisionRequestDto(comment: comment)))
        case .userRating(let userId):
            return Endpoint(service: .credit, method: .GET, path: "/api/credits/users/\(userId.uuidString.lowercased())/rating")
        }
    }
}

