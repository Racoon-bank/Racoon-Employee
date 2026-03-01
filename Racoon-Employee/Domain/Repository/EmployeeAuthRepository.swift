//
//  EmployeeAuthRepository.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


public protocol EmployeeAuthRepository: Sendable, TokenRefresher {
    func login(email: String, password: String) async throws -> AuthTokensDto
    func refresh(refreshToken: String) async throws -> AuthTokensDto
    func logout(accessToken: String?) async throws
}
