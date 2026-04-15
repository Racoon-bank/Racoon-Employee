//
//  AppSettingsStore.swift
//  Racoon-Employee
//
//  Created by dark type on 30.03.2026.
//


import Combine
import Foundation

@MainActor
public final class AppSettingsStore: ObservableObject {
    @Published private(set) var settings: AppSettings = AppSettings()

    private let storage: AppSettingsStorage
    private let syncTheme: SyncThemeFromProfileUseCase
    private let eventBus: DomainEventBus

    init(
        storage: AppSettingsStorage,
        syncTheme: SyncThemeFromProfileUseCase,
        eventBus: DomainEventBus
    ) {
        self.storage = storage
        self.syncTheme = syncTheme
        self.eventBus = eventBus
        
        self.settings = storage.load()
        
        listenForEvents()
    }

    private func listenForEvents() {
        Task {
            for await event in eventBus.events {
             
                if case .themeSwitched = event {
                    self.settings = storage.load()
                }
            }
        }
    }

    func bootstrapLocal() {
        self.settings = storage.load()
    }

    func syncFromBackend() async {
        _ = try? await syncTheme()
        
        self.settings = storage.load()
    }
}
