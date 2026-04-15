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
    public let appSettingsStorage: AppSettingsStorage
    public let appSettingsStore: AppSettingsStore
    
    public let appErrorBus: AppErrorBus

    // MARK: - Repositories
    public let authRepository: any EmployeeAuthRepository
    public let tokenRefresher: any TokenRefresher

    public let usersRepository: EmployeeUsersRepository
    public let accountsRepository: EmployeeAccountsRepository
    public let creditsRepository: EmployeeCreditsRepository
    public let tariffsRepository: EmployeeTariffsRepository
    public let appRepository: AppRepository

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
    
    public let connectBankHubUseCase: ConnectBankHubUseCase
    public let disconnectBankHubUseCase: DisconnectBankHubUseCase
    public let subscribeToAccountUseCase: SubscribeToAccountUseCase
    public let unsubscribeFromAccountUseCase: UnsubscribeFromAccountUseCase

    public let getTariffsUseCase: GetTariffsUseCase
    public let createTariffUseCase: CreateTariffUseCase
    public let deleteTariffUseCase: DeleteTariffUseCase
    public let completeSSOUseCase : CompleteSSOLoginUseCase
    public let setThemeUseCase: SetThemeUseCase
    public let syncThemeFromProfileUseCase: SyncThemeFromProfileUseCase
    
    public let bankHubClient: BankHubClient

    private init() {
        self.env = NetworkEnvironment.fromBuildConfig()
        self.networkingAssembly = NetworkingAssembly(env: env)
        self.eventBus = InMemoryDomainEventBus()
        self.appErrorBus = InMemoryAppErrorBus()
        self.repositoriesAssembly = RepositoriesAssembly(networking: networkingAssembly)
        
        self.tokenStore = networkingAssembly.makeTokenStore()
        self.bareHTTP = networkingAssembly.makeBareHTTPClient()
        self.appSettingsStorage = UserDefaultsAppSettingsStorage()
        self.bankHubClient = BankHubClient(env: env, tokenStore: tokenStore, eventBus: eventBus)
        
        
        let authLive = repositoriesAssembly.makeEmployeeAuthRepository(
            bareClient: bareHTTP,
            tokenStore: tokenStore
        )
        self.authRepository = authLive
        self.tokenRefresher = authLive
        
        
        self.authedHTTP = networkingAssembly.makeAuthedHTTPClient(
            tokenStore: tokenStore,
            tokenRefresher: tokenRefresher,
            appErrorBus: appErrorBus
        )
        
        
        self.usersRepository = repositoriesAssembly.makeEmployeeUsersRepository(authedClient: authedHTTP)
        self.accountsRepository = repositoriesAssembly.makeEmployeeAccountsRepository(authedClient: authedHTTP)
        self.creditsRepository = repositoriesAssembly.makeEmployeeCreditsRepository(authedClient: authedHTTP)
        self.tariffsRepository = repositoriesAssembly.makeEmployeeTariffsRepository(authedClient: authedHTTP)
        self.appRepository = AppRepositoryLive(client: authedHTTP)
        
        
        let useCases = UseCasesAssembly(
            authRepo: authRepository,
            usersRepo: usersRepository,
            accountsRepo: accountsRepository,
            creditsRepo: creditsRepository,
            tariffsRepo: tariffsRepository,
            tokenStore: tokenStore,
            events: eventBus,
            bankHubClient: bankHubClient
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
        self.completeSSOUseCase = CompleteSSOLoginUseCaseImpl(tokenStore: tokenStore, events: eventBus)
        self.setThemeUseCase = SetThemeUseCaseImpl(
            appRepo: self.appRepository,
            storage: appSettingsStorage,
            events: eventBus
        )
        
        self.syncThemeFromProfileUseCase = SyncThemeFromProfileUseCaseImpl(
            appRepo: self.appRepository,
            storage: appSettingsStorage,
            events: eventBus
        )
        
        
        self.appSettingsStore = AppSettingsStore(storage: appSettingsStorage , syncTheme: syncThemeFromProfileUseCase, eventBus: eventBus)
        
        
        self.connectBankHubUseCase = useCases.makeConnectBankHubUseCase()
        self.disconnectBankHubUseCase = useCases.makeDisconnectBankHubUseCase()
        self.subscribeToAccountUseCase = useCases.makeSubscribeToAccountUseCase()
        self.unsubscribeFromAccountUseCase = useCases.makeUnsubscribeFromAccountUseCase()
    }
}
