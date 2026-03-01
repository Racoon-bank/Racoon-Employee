//
//  EmployeeAuthRepositoryLive.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


public final class EmployeeAuthRepositoryLive: EmployeeAuthRepository {
    private let bareClient: HTTPClient
    private let tokenStore: TokenStore

    public init(bareClient: HTTPClient, tokenStore: TokenStore) {
        self.bareClient = bareClient
        self.tokenStore = tokenStore
    }

    public func login(email: String, password: String) async throws -> AuthTokensDto {
        let dto = try await bareClient.send(InfoRouter.login(email: email, password: password), as: AuthTokensDto.self)
        await tokenStore.saveTokens(.init(accessToken: dto.accessToken, refreshToken: dto.refreshToken))
        return dto
    }

    public func refresh(refreshToken: String) async throws -> AuthTokensDto {
        let dto = try await bareClient.send(InfoRouter.refresh(refreshToken: refreshToken), as: AuthTokensDto.self)
        await tokenStore.saveTokens(.init(accessToken: dto.accessToken, refreshToken: dto.refreshToken))
        return dto
    }

    public func refreshTokens(current: AuthTokens) async throws -> AuthTokens {
        let dto = try await refresh(refreshToken: current.refreshToken)
        return AuthTokens(accessToken: dto.accessToken, refreshToken: dto.refreshToken)
    }

    public func logout(accessToken: String? = nil) async throws {
        let token: String?

        if let accessToken, !accessToken.isEmpty {
            token = accessToken
        } else {
            token = await tokenStore.readTokens()?.accessToken
        }

        guard let token, !token.isEmpty else {
            await tokenStore.clearTokens()
            return
        }

        try await bareClient.sendNoResponse(InfoRouter.logout(accessToken: token))
        await tokenStore.clearTokens()
    }
}
