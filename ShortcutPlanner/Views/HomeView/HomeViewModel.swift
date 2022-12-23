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
    private let sirService = SiriService.shared
    private let dataStore = ShortcutStore.shared
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
    
    func runShortcut(_ shortcut: Shortcut) {
        /*
         let shortcut = URL(string: "shortcuts://x-callback-url/run-shortcut?name=Take%20Picture&x-success=myapp://")!
         UIApplication.shared.open(shortcut, options: [:], completionHandler: nil)
         */
        guard let escapedString = shortcut.title.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            print("error escaping string")
            return
        }
        print("shortcutURL: \(escapedString)")
        guard let shortcut = URL(string: "shortcuts://x-callback-url/run-shortcut?name=\(escapedString)&x-success=ShortcutPlanner://") else {
            print("Error for shortcut!: \(escapedString)")
            return
        }
        UIApplication.shared.open(shortcut, options: [:], completionHandler: nil)
        print("Shortcut: \(shortcut)")
        
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

/*
 "Play Castro",
 "Skip this episode",
 "Get My Shortcuts",
 "Turn On Overhead Lights",
 "Go To Sleep",
 "Morning Hydration",
 "Add an Espresso",
 "Add A Cold Brew",
 "Post Workout",
 "Add Green Tea",
 "Add A Large Coffee",
 "Add A Medium Coffee",
 "Add A Large Cold Brew",
 "Add A Protein Shake",
 "Sweetgreen Order",
 "Chipotle Order"
 */
