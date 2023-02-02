//
//  Shortcut.swift
//  ShortcutPlanner
//
//  Created by Frank Oftring on 12/21/22.
//

import Foundation
class Shortcut: ObservableObject, Identifiable, Equatable, Codable, NSCoding {
    let id: UUID
    let title: String
    var isComplete: Bool
    var reminder: Reminder? 
    var order: Int
    
    required init?(coder: NSCoder) {
        self.id = coder.decodeObject(forKey: "id") as! UUID
        self.title = coder.decodeObject(forKey: "title") as! String
        self.isComplete = coder.decodeBool(forKey: "isComplete")
        self.order = coder.decodeInteger(forKey: "order")
        self.reminder = coder.decodeObject(forKey: "reminder") as? Reminder
    }
    
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
    
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(title, forKey: "title")
        coder.encode(isComplete, forKey: "isComplete")
        coder.encode(order, forKey: "order")
        coder.encode(reminder, forKey: "reminder")
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
