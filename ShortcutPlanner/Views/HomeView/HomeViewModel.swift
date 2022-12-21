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
    let sirService = SiriService.shared
    var cancellables = Set<AnyCancellable>()
    let dataStore = ShortcutStore.shared
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
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        $offset
            .sink { offest in
                print("Offset -- \(offest)")
            }
            .store(in: &cancellables)
        
        dataStore.$shortcuts
            .receive(on: DispatchQueue.main)
            .sink { shortcuts in
                print("Updating shortcuts!! \(shortcuts)")
                self.shortcuts = shortcuts
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
        if let index = shortcuts.firstIndex(where: { $0.title == shortcut.title }) {
            shortcuts.remove(at: index)
        }
    }
}
