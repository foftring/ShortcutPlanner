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
    @Published var cards: [Card] = []
    let sirService = SiriService.shared
    var cancellables = Set<AnyCancellable>()
    let myShortcuts: [String] = [
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
    ]
    
    init() {
        getCards()
        addSubscribers()
    }
    
    func getCards() {
        for index in 0..<10 {
            let shortcut = myShortcuts[index]
            cards.append(Card(title: shortcut))
            print("appending shortcut \(shortcut)")
        }
    }
    
    func addSubscribers() {
        $offset
            .sink { offest in
                print("Offset -- \(offest)")
            }
            .store(in: &cancellables)
    }
    
    func runShortcut(_ card: Card) {
        /*
         let shortcut = URL(string: "shortcuts://x-callback-url/run-shortcut?name=Take%20Picture&x-success=myapp://")!
         UIApplication.shared.open(shortcut, options: [:], completionHandler: nil)
         */
        guard let escapedString = card.title.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
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
    
    func removeCard(card: Card) {
        if let index = cards.firstIndex(where: { $0.title == card.title }) {
            cards.remove(at: index)
        }
    }
}
