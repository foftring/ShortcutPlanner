//
//  Shortcut.swift
//  ShortcutPlanner
//
//  Created by Frank Oftring on 12/21/22.
//

import Foundation
class Shortcut: ObservableObject, Identifiable, Equatable, Codable {
    let id: UUID
    let title: String
    var isComplete: Bool
    var reminder: Reminder? 
    var order: Int
    
    init(id: UUID, title: String, isComplete: Bool = false, order: Int, reminder: Reminder? = nil) {
        self.id = id
        self.title = title
        self.isComplete = isComplete
        self.order = order
        self.reminder = reminder
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

enum ReminderType: Int, CaseIterable, Identifiable, Codable {
  case time
  case calendar
  var id: Int { self.rawValue }
}

struct Reminder: Codable {
  var timeInterval: TimeInterval?
  var date: Date?
  var reminderType: ReminderType = .time
  var repeats = false
}
