//
//  AppContainer.swift
//  Racoon-client
//
//  Created by dark type on 26.02.2026.
//


import Foundation

public final class AppContainer: @unchecked Sendable {
    public static let shared = AppContainer()

    private let env: NetworkEnvironment
    private let networkingAssembly: NetworkingAssembly
    private let repositoriesAssembly: RepositoriesAssembly

    // MARK: - Core
    public let tokenStore: TokenStore
    public let bareHTTP: HTTPClient
    public let authedHTTP: HTTPClient
    public let eventBus: DomainEventBus

    // MARK: - Repositories
    public let authRepository: any EmployeeAuthRepository
    public let tokenRefresher: any TokenRefresher

    public let usersRepository: EmployeeUsersRepository
    public let accountsRepository: EmployeeAccountsRepository
    public let creditsRepository: EmployeeCreditsRepository
    public let tariffsRepository: EmployeeTariffsRepository

    // MARK: - Use cases
    public let loginUseCase: EmployeeLoginUseCase
    public let logoutUseCase: EmployeeLogoutUseCase

    public let getAllUsersUseCase: GetAllUsersUseCase
    public let createUserUseCase: CreateUserUseCase
    public let createEmployeeUseCase: CreateEmployeeUseCase
    public let banUserUseCase: BanUserUseCase

    public let getAllAccountsUseCase: GetAllAccountsUseCase
    public let getUserAccountsUseCase: GetUserAccountsUseCase
    public let getAccountHistoryUseCase: GetAccountHistoryUseCase

    public let getAllCreditsUseCase: GetAllCreditsUseCase
    public let getCreditUseCase: GetCreditUseCase
    public let getCreditStatisticsUseCase: GetCreditStatisticsUseCase
    public let getCreditScheduleUseCase: GetCreditScheduleUseCase
    public let getCreditPaymentsUseCase: GetCreditPaymentsUseCase

    public let getTariffsUseCase: GetTariffsUseCase
    public let createTariffUseCase: CreateTariffUseCase
    public let deleteTariffUseCase: DeleteTariffUseCase

    private init() {
        self.env = NetworkEnvironment.fromBuildConfig()
        self.networkingAssembly = NetworkingAssembly(env: env)
        self.repositoriesAssembly = RepositoriesAssembly(networking: networkingAssembly)

        // Networking primitives
        self.tokenStore = networkingAssembly.makeTokenStore()
        self.bareHTTP = networkingAssembly.makeBareHTTPClient()

        // Auth repo must be created BEFORE authed client (for refresh)
        let authLive = repositoriesAssembly.makeEmployeeAuthRepository(
            bareClient: bareHTTP,
            tokenStore: tokenStore
        )
        self.authRepository = authLive
        self.tokenRefresher = authLive
        self.eventBus = InMemoryDomainEventBus()

        self.authedHTTP = networkingAssembly.makeAuthedHTTPClient(
            tokenStore: tokenStore,
            tokenRefresher: tokenRefresher
        )

        // Repos (authed)
        self.usersRepository = repositoriesAssembly.makeEmployeeUsersRepository(authedClient: authedHTTP)
        self.accountsRepository = repositoriesAssembly.makeEmployeeAccountsRepository(authedClient: authedHTTP)
        self.creditsRepository = repositoriesAssembly.makeEmployeeCreditsRepository(authedClient: authedHTTP)
        self.tariffsRepository = repositoriesAssembly.makeEmployeeTariffsRepository(authedClient: authedHTTP)
        
        let useCases = UseCasesAssembly(
            authRepo: authRepository,
            usersRepo: usersRepository,
            accountsRepo: accountsRepository,
            creditsRepo: creditsRepository,
            tariffsRepo: tariffsRepository,
            tokenStore: tokenStore,
            events: eventBus
        )

        // Auth
        self.loginUseCase = useCases.makeLoginUseCase()
        self.logoutUseCase = useCases.makeLogoutUseCase()

        // Users
        self.getAllUsersUseCase = useCases.makeGetAllUsersUseCase()
        self.createUserUseCase = useCases.makeCreateUserUseCase()
        self.createEmployeeUseCase = useCases.makeCreateEmployeeUseCase()
        self.banUserUseCase = useCases.makeBanUserUseCase()

        // Accounts
        self.getAllAccountsUseCase = useCases.makeGetAllAccountsUseCase()
        self.getUserAccountsUseCase = useCases.makeGetUserAccountsUseCase()
        self.getAccountHistoryUseCase = useCases.makeGetAccountHistoryUseCase()

        // Credits
        self.getAllCreditsUseCase = useCases.makeGetAllCreditsUseCase()
        self.getCreditUseCase = useCases.makeGetCreditUseCase()
        self.getCreditStatisticsUseCase = useCases.makeGetCreditStatisticsUseCase()
        self.getCreditScheduleUseCase = useCases.makeGetCreditScheduleUseCase()
        self.getCreditPaymentsUseCase = useCases.makeGetCreditPaymentsUseCase()

        // Tariffs
        self.getTariffsUseCase = useCases.makeGetTariffsUseCase()
        self.createTariffUseCase = useCases.makeCreateTariffUseCase()
        self.deleteTariffUseCase = useCases.makeDeleteTariffUseCase()
    }
}
