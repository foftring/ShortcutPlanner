//
//  Shortcut.swift
//  ShortcutPlanner
//
//  Created by Frank Oftring on 12/21/22.
//

import Foundation
class Shortcut: Identifiable, Equatable {
    let id = UUID()
    let title: String
    var isComplete: Bool
    
    init(title: String, isComplete: Bool = false) {
        self.title = title
        self.isComplete = isComplete
    }
}

extension Shortcut {
    static func == (lhs: Shortcut, rhs: Shortcut) -> Bool {
        lhs.id == rhs.id
    }
}
