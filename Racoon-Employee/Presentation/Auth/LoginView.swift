//
//  LoginView.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel

    private enum Field: Hashable {
        case email
        case password
    }

    @FocusState private var focusedField: Field?

    init(viewModel: LoginViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Employee console")
                        .font(.title2).bold()
                    Text("Sign in to manage users, accounts, credits, and tariffs.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 6)
            }

            Section("Credentials") {
                TextField("Email", text: $viewModel.email)
                    .textContentType(.username)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .submitLabel(.next)
                    .focused($focusedField, equals: .email)
                    .onSubmit { focusedField = .password }

                SecureField("Password", text: $viewModel.password)
                    .textContentType(.password)
                    .textInputAutocapitalization(.never)
                    .submitLabel(.go)
                    .focused($focusedField, equals: .password)
                    .onSubmit { Task { await viewModel.submit() } }
            }

            Section {
                Button {
                    Task { await viewModel.submit() }
                } label: {
                    HStack {
                        Spacer()
                        if viewModel.state.isLoading {
                            ProgressView().controlSize(.small)
                                .padding(.trailing, 6)
                        }
                        Text(viewModel.state.isLoading ? "Signing in…" : "Sign in")
                            .font(.headline)
                        Spacer()
                    }
                }
                .disabled(!viewModel.canSubmit)
            }
        }
        .navigationTitle("Sign in")
        .navigationBarTitleDisplayMode(.large)
        .onAppear { focusedField = .email }
        .alert("Error", isPresented: Binding(
            get: { viewModel.state.errorMessage != nil },
            set: { isPresented in if !isPresented { viewModel.clearError() } }
        )) {
            Button("OK", role: .cancel) { viewModel.clearError() }
        } message: {
            Text(viewModel.state.errorMessage ?? "")
        }
    }
}