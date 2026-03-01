//
//  CreateUserSheet.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


import SwiftUI

struct CreateUserSheet: View {
    let title: String
    let confirmTitle: String
    let onConfirm: (CreateUserInput) -> Void

    @Environment(\.dismiss) private var dismiss

    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""

    @State private var errorText: String?

    var body: some View {
        NavigationStack {
            Form {
                Section("User") {
                    TextField("Username", text: $username)
                        .textInputAutocapitalization(.words)

                    TextField("Email (optional)", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }

                Section("Password") {
                    SecureField("Password", text: $password)
                    SecureField("Confirm password", text: $confirmPassword)
                }

                if let errorText {
                    Section {
                        Text(errorText)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(confirmTitle) {
                        guard let input = parse() else { return }
                        onConfirm(input)
                        dismiss()
                    }
                    .disabled(parseSilent() == nil)
                }
            }
            .onChange(of: username) { _ in errorText = nil }
            .onChange(of: email) { _ in errorText = nil }
            .onChange(of: password) { _ in errorText = nil }
            .onChange(of: confirmPassword) { _ in errorText = nil }
        }
    }

    private func parseSilent() -> CreateUserInput? {
        let u = username.trimmingCharacters(in: .whitespacesAndNewlines)
        guard u.count >= 2 else { return nil }

        let p = password
        guard p.count >= 4 else { return nil }
        guard confirmPassword == p else { return nil }

        let e = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailValue: String? = e.isEmpty ? nil : e

        return CreateUserInput(username: u, email: emailValue, password: p)
    }

    private func parse() -> CreateUserInput? {
        guard let input = parseSilent() else {
            errorText = "Check all fields. Passwords must match."
            return nil
        }
        return input
    }
}