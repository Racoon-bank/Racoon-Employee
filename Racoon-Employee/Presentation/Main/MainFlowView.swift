//
//  MainFlowView.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


import SwiftUI

struct MainFlowView: View {
    var body: some View {
        TabView {
            AccountsAdminFlowView()
                .tabItem { Label("Accounts", systemImage: "banknote") }

            CreditsAdminFlowView()
                .tabItem { Label("Credits", systemImage: "doc.text.magnifyingglass") }

            TariffsAdminFlowView()
                .tabItem { Label("Tariffs", systemImage: "percent") }

            UsersAdminFlowView()
                .tabItem { Label("Users", systemImage: "person.2") }
        }
    }
}