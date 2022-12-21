//
//  ShortcutStore.swift
//  ShortcutPlanner
//
//  Created by Frank Oftring on 12/20/22.
//

import Foundation
class ShortcutStore: ObservableObject {
    
    static let shared = ShortcutStore()
    
    private init() { }
    
    @Published var shortcuts: [Shortcut] = []
}
