//
//  EmployeeLoginUseCase.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


import Foundation

public protocol EmployeeLoginUseCase: Sendable {
    func callAsFunction(email: String, password: String) async throws
}

public struct EmployeeLoginUseCaseImpl: EmployeeLoginUseCase {
    private let authRepo: EmployeeAuthRepository

    public init(authRepo: EmployeeAuthRepository) {
        self.authRepo = authRepo
    }

    public func callAsFunction(email: String, password: String) async throws {
        _ = try await authRepo.login(email: email, password: password)
    }
}