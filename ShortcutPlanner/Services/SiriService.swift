//
//  SiriService.swift
//  ShortcutPlanner
//
//  Created by Frank Oftring on 12/3/22.
//

import Foundation
import Intents
import SafariServices

class SiriService {
    static let shared = SiriService()
    
    @Published var shortcuts: [INVoiceShortcut] = []
    let center = INVoiceShortcutCenter.shared

    
    init() {
        requestAuthorization()
        getShortcuts()
    }
    
    func requestAuthorization() {
        INPreferences.requestSiriAuthorization({status in
            // Handle errors here
        })
    }
    
    func getShortcuts() {
        center.getAllVoiceShortcuts(completion: { (shortcuts, error) in
            if let error = error {
                print("Error getting shortcuts: \(error)")
            } else if let shortcuts = shortcuts {
                self.shortcuts.append(contentsOf: shortcuts)
                shortcuts.forEach { shortcut in
                    print("invocationPhrase: \(shortcut.invocationPhrase)")
                    print("shortcut.description: \(shortcut.shortcut.description)")
                    print("description: \(shortcut.description)")
                    print("shortcut.shortcut.intent: \(shortcut.shortcut.intent)")
                }
            }
        })
    }
    
    func handleShortcut(shortcut: INVoiceShortcut) {
        shortcut.invocationPhrase
    }
}
