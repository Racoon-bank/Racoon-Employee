//
//  UseCasesAssembly.swift
//  Racoon-client
//
//  Created by dark type on 27.02.2026.
//


import Foundation

public struct UseCasesAssembly: Sendable {
    private let authRepo: EmployeeAuthRepository
    private let usersRepo: EmployeeUsersRepository
    private let accountsRepo: EmployeeAccountsRepository
    private let creditsRepo: EmployeeCreditsRepository
    private let tariffsRepo: EmployeeTariffsRepository
    private let tokenStore: TokenStore
    private let events: DomainEventBus?

    public init(
        authRepo: EmployeeAuthRepository,
        usersRepo: EmployeeUsersRepository,
        accountsRepo: EmployeeAccountsRepository,
        creditsRepo: EmployeeCreditsRepository,
        tariffsRepo: EmployeeTariffsRepository,
        tokenStore: TokenStore,
        events: DomainEventBus? = nil
    ) {
        self.authRepo = authRepo
        self.usersRepo = usersRepo
        self.accountsRepo = accountsRepo
        self.creditsRepo = creditsRepo
        self.tariffsRepo = tariffsRepo
        self.tokenStore = tokenStore
        self.events = events
    }

    
    public func makeLoginUseCase() -> EmployeeLoginUseCase {
        EmployeeLoginUseCaseImpl(authRepo: authRepo)
    }

    public func makeLogoutUseCase() -> EmployeeLogoutUseCase {
        EmployeeLogoutUseCaseImpl(authRepo: authRepo, tokenStore: tokenStore)
    }

    public func makeGetAllAccountsUseCase() -> GetAllAccountsUseCase {
        GetAllAccountsUseCaseImpl(repo: accountsRepo)
    }

    public func makeGetUserAccountsUseCase() -> GetUserAccountsUseCase {
        GetUserAccountsUseCaseImpl(repo: accountsRepo)
    }

    public func makeGetAccountHistoryUseCase() -> GetAccountHistoryUseCase {
        GetAccountHistoryUseCaseImpl(repo: accountsRepo)
    }

    public func makeGetAllUsersUseCase() -> GetAllUsersUseCase {
        GetAllUsersUseCaseImpl(repo: usersRepo)
    }

    public func makeCreateUserUseCase() -> CreateUserUseCase {
        CreateUserUseCaseImpl(repo: usersRepo, events: events)
    }

    public func makeCreateEmployeeUseCase() -> CreateEmployeeUseCase {
        CreateEmployeeUseCaseImpl(repo: usersRepo, events: events)
    }

    public func makeBanUserUseCase() -> BanUserUseCase {
        BanUserUseCaseImpl(repo: usersRepo, events: events)
    }

    public func makeGetAllCreditsUseCase() -> GetAllCreditsUseCase {
        GetAllCreditsUseCaseImpl(repo: creditsRepo)
    }

    public func makeGetCreditUseCase() -> GetCreditUseCase {
        GetCreditUseCaseImpl(repo: creditsRepo)
    }

    public func makeGetCreditStatisticsUseCase() -> GetCreditStatisticsUseCase {
        GetCreditStatisticsUseCaseImpl(repo: creditsRepo)
    }

    public func makeGetCreditScheduleUseCase() -> GetCreditScheduleUseCase {
        GetCreditScheduleUseCaseImpl(repo: creditsRepo)
    }

    public func makeGetCreditPaymentsUseCase() -> GetCreditPaymentsUseCase {
        GetCreditPaymentsUseCaseImpl(repo: creditsRepo)
    }

    public func makeGetTariffsUseCase() -> GetTariffsUseCase {
        GetTariffsUseCaseImpl(repo: tariffsRepo)
    }

    public func makeCreateTariffUseCase() -> CreateTariffUseCase {
        CreateTariffUseCaseImpl(repo: tariffsRepo, events: events)
    }

    public func makeDeleteTariffUseCase() -> DeleteTariffUseCase {
        DeleteTariffUseCaseImpl(repo: tariffsRepo, events: events)
    }
}
