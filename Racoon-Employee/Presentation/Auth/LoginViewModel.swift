//
//  LoginViewModel.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


import Foundation
import Combine

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""

    @Published private(set) var state: AsyncViewState = .idle

    private let login: EmployeeLoginUseCase
    private unowned let appState: AppState

    init(login: EmployeeLoginUseCase, appState: AppState) {
        self.login = login
        self.appState = appState
    }

    var canSubmit: Bool {
        isValidEmail(email) && password.count >= 4 && !state.isLoading
    }

    func submit() async {
        guard canSubmit else { return }
        state = .loading
        defer { if case .loading = state { state = .idle } }

        do {
            try await login(
                email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                password: password
            )
            state = .success
            appState.onLoggedIn()
        } catch {
            state = .error(message: humanize(error))
        }
    }

    func clearError() {
        if case .error = state { state = .idle }
    }
}

// MARK: - Helpers
private extension LoginViewModel {
    func isValidEmail(_ s: String) -> Bool {
        let t = s.trimmingCharacters(in: .whitespacesAndNewlines)
        return t.contains("@") && t.contains(".") && t.count >= 5
    }

    func humanize(_ error: Error) -> String {
        if let e = error as? NetworkError {
            switch e {
            case .unauthorized:
                return "Invalid credentials."
            case .httpStatus(let code, _):
                return "Server error (\(code)). Please try again."
            case .decoding:
                return "Unexpected server response."
            default:
                return "Login failed. Please try again."
            }
        }
        return "Login failed. Please try again."
    }
}
