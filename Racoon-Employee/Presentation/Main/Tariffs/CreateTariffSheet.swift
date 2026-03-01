//
//  CreateTariffSheet.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


import SwiftUI

struct CreateTariffSheet: View {
    let onConfirm: (CreateTariffInput) -> Void
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var interestRateText: String = ""
    @State private var dueDate: Date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    @State private var isActive: Bool = true

    @State private var errorText: String?

    var body: some View {
        NavigationStack {
            Form {
                Section("Tariff") {
                    TextField("Name", text: $name)
                        .textInputAutocapitalization(.words)

                    TextField("Interest rate (%)", text: $interestRateText)
                        .keyboardType(.decimalPad)
                }

                Section("Due date") {
                    DatePicker("Due date", selection: $dueDate, displayedComponents: [.date])
                }

                Section {
                    Toggle("Active", isOn: $isActive)
                }

                if let errorText {
                    Section {
                        Text(errorText)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("New tariff")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Create") {
                        guard let input = parse() else { return }
                        onConfirm(input)
                        dismiss()
                    }
                    .disabled(parseSilent() == nil)
                }
            }
            .onChange(of: name) { _ in errorText = nil }
            .onChange(of: interestRateText) { _ in errorText = nil }
        }
    }

    private func parseSilent() -> CreateTariffInput? {
        let tName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard tName.count >= 2 else { return nil }

        let normalized = interestRateText.replacingOccurrences(of: ",", with: ".")
        guard let rate = Decimal(string: normalized), rate >= 0 else { return nil }

        return CreateTariffInput(
            name: tName,
            interestRate: rate,
            dueDate: dueDate,
            isActive: isActive
        )
    }

    private func parse() -> CreateTariffInput? {
        guard let input = parseSilent() else {
            errorText = "Fill name and a valid interest rate."
            return nil
        }
        return input
    }
}