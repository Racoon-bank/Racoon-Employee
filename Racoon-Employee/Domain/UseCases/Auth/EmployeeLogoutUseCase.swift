//
//  EmployeeLogoutUseCase.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


public protocol EmployeeLogoutUseCase: Sendable {
    func callAsFunction() async throws
}

public struct EmployeeLogoutUseCaseImpl: EmployeeLogoutUseCase {
    private let authRepo: EmployeeAuthRepository
    private let tokenStore: TokenStore

    public init(authRepo: EmployeeAuthRepository, tokenStore: TokenStore) {
        self.authRepo = authRepo
        self.tokenStore = tokenStore
    }

    public func callAsFunction() async throws {
        let token = await tokenStore.readTokens()?.accessToken
        try await authRepo.logout(accessToken: token)
    }
}
