//
//  PreviewProvider.swift
//  ShortcutPlanner
//
//  Created by Frank Oftring on 12/20/22.
//

import SwiftUI

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
}

class DeveloperPreview {
    @Published var shortcuts: [Shortcut] = []
    static let instance = DeveloperPreview()
    
    var shotcut = Shortcut(id: UUID(), title: "Log my meal", order: 2)
    
    init() {
        getCards()
    }
    
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
    
    func getCards() {
            for index in 0..<10 {
                let shortcut = myShortcuts[index]
                shortcuts.append(Shortcut(id: UUID(), title: shortcut, order: index))
                print("appending shortcut \(shortcut)")
            }
        }
}
