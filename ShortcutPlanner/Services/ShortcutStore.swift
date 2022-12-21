//
//  ShortcutStore.swift
//  ShortcutPlanner
//
//  Created by Frank Oftring on 12/20/22.
//
import Combine
import Foundation
class ShortcutStore: ObservableObject {
    
    static let shared = ShortcutStore()
    let coreDataStore = CoreDataService.shared
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        addSubscribers()
    }
    
    @Published var shortcuts: [Shortcut] = []
    
    func addSubscribers() {
        coreDataStore.$savedStats
            .receive(on: DispatchQueue.main)
            .sink { shortcutEntities in
                self.shortcuts = shortcutEntities.map({ Shortcut(title: $0.title ?? "") })
            }
            .store(in: &cancellables)
    }
    
    func updateShortcut(shortcut: Shortcut) {
        coreDataStore.add(shortcut: shortcut)
    }
}
