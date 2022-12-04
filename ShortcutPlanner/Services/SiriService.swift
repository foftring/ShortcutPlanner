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
//        getShortcuts()
    }
    
    func requestAuthorization() {
        INPreferences.requestSiriAuthorization({status in
            // Handle errors here
            if status == .authorized {
                print("Authorized")
                Task {
                    await self.getShortcuts()
                }
            }
        })
    }
    
    func getShortcuts() async {
        do {
            let shortcuts = try await center.allVoiceShortcuts()
            self.shortcuts.append(contentsOf: shortcuts)
            shortcuts.forEach { shortcut in
                print("invocationPhrase: \(shortcut.invocationPhrase)")
                print("shortcut.description: \(shortcut.shortcut.description)")
                print("description: \(shortcut.description)")
                print("shortcut.shortcut.intent: \(shortcut.shortcut.intent)")
            }
        } catch let error {
            print("Error getting shortcuts: \(error)")
        }
    }
    
    
}


