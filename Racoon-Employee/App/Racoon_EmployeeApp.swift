//
//  Racoon_EmployeeApp.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//

import SwiftUI

@main
struct Racoon_EmployeeApp: App {
    @StateObject private var appState: AppState
       private let container: AppContainer

       init() {
           let container = AppContainer.shared
           self.container = container
           _appState = StateObject(wrappedValue: AppState(container: container))
       }

       var body: some Scene {
           WindowGroup {
               RootView()
                   .environment(\.appContainer, container)
                   .environmentObject(appState)
           }
       }
   }
