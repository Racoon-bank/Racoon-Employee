//
//  RepositoriesAssembly.swift
//  Racoon-client
//
//  Created by dark type on 27.02.2026.
//


public struct RepositoriesAssembly: Sendable {
    public let networking: NetworkingAssembly

    public init(networking: NetworkingAssembly) {
        self.networking = networking
    }

    public func makeEmployeeAuthRepository(
        bareClient: HTTPClient,
        tokenStore: TokenStore
    ) -> EmployeeAuthRepositoryLive {
        EmployeeAuthRepositoryLive(bareClient: bareClient, tokenStore: tokenStore)
    }

    public func makeEmployeeUsersRepository(authedClient: HTTPClient) -> EmployeeUsersRepository {
        EmployeeUsersRepositoryLive(client: authedClient)
    }

    // CORE
    public func makeEmployeeAccountsRepository(authedClient: HTTPClient) -> EmployeeAccountsRepository {
        EmployeeAccountsRepositoryLive(client: authedClient)
    }

    // CREDIT
    public func makeEmployeeTariffsRepository(authedClient: HTTPClient) -> EmployeeTariffsRepository {
        EmployeeTariffsRepositoryLive(client: authedClient)
    }

    public func makeEmployeeCreditsRepository(authedClient: HTTPClient) -> EmployeeCreditsRepository {
        EmployeeCreditsRepositoryLive(client: authedClient)
    }
}
