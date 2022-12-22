//
//  ShortcutStore.swift
//  ShortcutPlanner
//
//  Created by Frank Oftring on 12/20/22.
//
import Combine
import Foundation
class ShortcutStore: ObservableObject {
    
    @Published var shortcuts: [Shortcut] = []
    static let shared = ShortcutStore()
    private let coreDataStore = CoreDataService.shared
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        addSubscribers()
    }
    
    private func addSubscribers() {
        coreDataStore.$savedStats
            .receive(on: DispatchQueue.main)
            .sink { shortcutEntities in
                print("subscription updated!")
                let mappedShortcuts = shortcutEntities.map({ Shortcut(title: $0.title ?? "", isComplete: $0.isComplete) })
                self.shortcuts = mappedShortcuts.filter { !$0.isComplete }
                print("incompleteShortcuts from dataStore: \(self.shortcuts.count)")
            }
            .store(in: &cancellables)
    }
    
    func updateShortcut(shortcut: Shortcut) {
        coreDataStore.updateStats(shortcut: shortcut, isComplete: true)
    }
    
    func resetShortcuts() {
        shortcuts.forEach({
            $0.isComplete = false
            print("Changing complete for \($0) -- isComplete: \($0.isComplete)")
        })
    }
}
