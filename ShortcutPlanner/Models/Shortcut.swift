//
//  Shortcut.swift
//  ShortcutPlanner
//
//  Created by Frank Oftring on 12/21/22.
//

import Foundation
struct Shortcut: Identifiable, Equatable {
    let id = UUID()
    let title: String
    var isComplete: Bool = false
}
