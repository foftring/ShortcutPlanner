//
//  HomeViewModel.swift
//  ShortcutPlanner
//
//  Created by Frank Oftring on 12/3/22.
//

import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var offset: CGSize = .zero
    @Published var shortcuts: [Shortcut] = []
    @Published var hasImportedShortcuts: Bool = false
    @Published var isFinished: Bool = false
    @Published var showingAlert = false
    private let sirService = SiriService.shared
    private let dataStore = ShortcutStore.shared
    @Published var notificationService = NotificationService.shared
    private let coreDataService = CoreDataService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        dataStore.$shortcuts
            .receive(on: DispatchQueue.main)
            .sink { shortcuts in
                print("Updating shortcuts!! \(shortcuts) -- shortcutsCount from vM: \(shortcuts.count) -- uncompleted \(shortcuts.filter({!$0.isComplete}).count)")
                self.shortcuts = shortcuts.sorted(by: { $0.order < $1.order })
                if shortcuts.allSatisfy({ $0.isComplete }) {
                    self.isFinished = true
                } else {
                    self.isFinished = false
                }
            }
            .store(in: &cancellables)
        
        coreDataService.$savedStats
            .receive(on: DispatchQueue.main)
            .sink { savedStats in
                if !savedStats.isEmpty { self.hasImportedShortcuts = true }
            }
            .store(in: &cancellables)
            
    }
    
    func getNotificationAuthorization() async {
        try? await notificationService.requestAuthorization()
        if !notificationService.authorized {
            DispatchQueue.main.async {
                self.showingAlert = true
            }
        }
    }
    
    func runShortcut(_ shortcut: Shortcut) {
        dataStore.runShortcut(shortcut)
    }
    
    func removeCard(shortcut: Shortcut) {
        shortcut.isComplete.toggle()
    }
    
    func resetAppValuesIfNewDay() {
        let currentDate = Date()
        if let lastLaunchDate = UserDefaults.standard.object(forKey: "lastLaunchDate") as? Date {
            let calendar = Calendar.current
            let isNewDay = calendar.isDateInToday(currentDate) != calendar.isDateInToday(lastLaunchDate)

            if isNewDay {
                print("Is new day!! Resetting shortcuts")
                dataStore.resetShortcuts()
            }
        } else {
            // lastLaunchDate is nil, so reset app values
            print("Last launch day is nil! Resetting shortcuts")
            dataStore.resetShortcuts()
        }
        print("setting userDefaults value for lastLaunchDate: \(currentDate)")
        UserDefaults.standard.set(currentDate, forKey: "lastLaunchDate")
    }

    func testReset() {
        dataStore.resetShortcuts()
    }
    
    func resetCoreData() {
        coreDataService.deleteAllData()
    }
    
    func updateShortcut(_ shortcut: Shortcut, shouldToggle: Bool = false) {
        if shouldToggle { shortcut.isComplete.toggle() }
        dataStore.updateShortcut(shortcut: shortcut)
    }
    

}


