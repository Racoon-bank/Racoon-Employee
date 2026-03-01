//
//  CreditRouter.swift
//  Racoon-client
//
//  Created by dark type on 26.02.2026.
//

import Foundation

import Foundation

public enum CreditRouter: APIRouter {
    // Tariffs
    case tariffs
    case tariff(id: Int64)

    // Employee tariffs
    case createTariff(name: String, interestRate: Double, dueDate: Date, isActive: Bool?)
    case deleteTariff(id: Int64)

    
    case allCredits
    case credit(id: Int64)
    case statistics(creditId: Int64)
    case schedule(creditId: Int64)
    case payments(creditId: Int64)

    public var endpoint: Endpoint {
        switch self {

        // MARK: - Tariffs (public)
        case .tariffs:
            return Endpoint(service: .credit, method: .GET, path: "/api/tariffs")

        case .tariff(let id):
            return Endpoint(service: .credit, method: .GET, path: "/api/tariffs/\(id)")

        // MARK: - Tariffs (employee)
        case .createTariff(let name, let interestRate, let dueDate, let isActive):
            return Endpoint(
                service: .credit,
                method: .POST,
                path: "/api/employee/tariffs",
                body: .json(CreditTariffRequestDto(
                    name: name,
                    interestRate: interestRate,
                    dueDate: dueDate,
                    isActive: isActive ?? true
                ))
            )
           
        case .deleteTariff(let id):
            return Endpoint(
                service: .credit,
                method: .DELETE,
                path: "/api/employee/tariffs/\(id)"
            )

        // MARK: - Credits
        case .allCredits:
            return Endpoint(service: .credit, method: .GET, path: "/api/credits")

        case .credit(let id):
            return Endpoint(service: .credit, method: .GET, path: "/api/credits/\(id)")

        case .statistics(let creditId):
            return Endpoint(service: .credit, method: .GET, path: "/api/credits/\(creditId)/statistics")

        case .schedule(let creditId):
            return Endpoint(service: .credit, method: .GET, path: "/api/credits/\(creditId)/schedule")

        case .payments(let creditId):
            return Endpoint(service: .credit, method: .GET, path: "/api/credits/\(creditId)/payments")
        }
    }
}


