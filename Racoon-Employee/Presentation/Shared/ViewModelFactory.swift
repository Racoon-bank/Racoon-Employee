//
//  ViewModelFactory.swift
//  Racoon-client
//
//  Created by dark type on 27.02.2026.
//


import Foundation

@MainActor
 struct ViewModelFactory: Sendable {
    private let container: AppContainer
     init(container: AppContainer) { self.container = container }

     public func makeLoginViewModel(appState: AppState) -> LoginViewModel {
         LoginViewModel(login: container.loginUseCase, appState: appState)
     }

    // MARK: - Admin
       func makeAccountsAdminHomeViewModel() -> AccountsAdminHomeViewModel {
         AccountsAdminHomeViewModel(getAllAccounts: container.getAllAccountsUseCase)
     }

      func makeAccountHistoryViewModel(accountId: UUID) -> AccountHistoryViewModel {
         AccountHistoryViewModel(accountId: accountId, getHistory: container.getAccountHistoryUseCase)
     }
     public func makeCreditsAdminHomeViewModel() -> CreditsAdminHomeViewModel {
         CreditsAdminHomeViewModel(getAllCredits: container.getAllCreditsUseCase)
     }

      func makeCreditAdminDetailsViewModel(creditId: Int64) -> CreditAdminDetailsViewModel {
         CreditAdminDetailsViewModel(
             creditId: creditId,
             getCredit: container.getCreditUseCase,
             getStatistics: container.getCreditStatisticsUseCase,
             getSchedule: container.getCreditScheduleUseCase,
             getPayments: container.getCreditPaymentsUseCase
         )
     }

      func makeTariffsAdminHomeViewModel() -> TariffsAdminHomeViewModel {
         TariffsAdminHomeViewModel(
             getTariffs: container.getTariffsUseCase,
             createTariff: container.createTariffUseCase,
             deleteTariff: container.deleteTariffUseCase
         )
     }
     public func makeUsersAdminHomeViewModel() -> UsersAdminHomeViewModel {
         UsersAdminHomeViewModel(
             getAllUsers: container.getAllUsersUseCase,
             createUser: container.createUserUseCase,
             createEmployee: container.createEmployeeUseCase,
             banUser: container.banUserUseCase
         )
     }
}
