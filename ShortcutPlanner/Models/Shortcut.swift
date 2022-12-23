//
//  Shortcut.swift
//  ShortcutPlanner
//
//  Created by Frank Oftring on 12/21/22.
//

import Foundation
class Shortcut: Identifiable, Equatable {
    let id: UUID
    let title: String
    var isComplete: Bool
    var order: Int
    
    init(id: UUID, title: String, isComplete: Bool = false, order: Int) {
        self.id = id
        self.title = title
        self.isComplete = isComplete
        self.order = order
    }
    
    func updateOrder(index: Int) {
        self.order = index
    }
}

extension Shortcut {
    static func == (lhs: Shortcut, rhs: Shortcut) -> Bool {
        lhs.id == rhs.id
    }
}
