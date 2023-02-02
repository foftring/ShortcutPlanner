//
//  NotificationService.swift
//  ShortcutPlanner
//
//  Created by Frank Oftring on 1/11/23.
//

import Foundation
import UserNotifications

class NotificationService: NSObject, ObservableObject {
    static let shared = NotificationService()
    @Published var authorized: Bool = false
    @Published var settings: UNNotificationSettings?
    @Published var pending: [UNNotificationRequest] = []
    @Published var delivered: [UNNotification] = []
    private let center = UNUserNotificationCenter.current()
    
    override init() {
      super.init()
      center.delegate = self
    }
    
    func requestAuthorization() async throws {
      authorized = try await center.requestAuthorization(options: [.badge, .sound, .alert])
    }

    @MainActor
    func refreshNotifications() async {
        pending = await center.pendingNotificationRequests()
        delivered = await center.deliveredNotifications()
        
    }
    
    func removePendingNotifications(identifiers: [String]) async {
      center.removePendingNotificationRequests(withIdentifiers: identifiers)
      await refreshNotifications()
    }

    func removeDeliveredNotifications(identifiers: [String]) async {
      center.removeDeliveredNotifications(withIdentifiers: identifiers)
      await refreshNotifications()
    }
    
    func scheduleNotification(trigger: UNNotificationTrigger, model: CommonFieldsModel) async throws {
        let title = model.title.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let content = UNMutableNotificationContent()
        content.title = title.isEmpty ? "No Title Provided" : title
        
        if model.hasSound {
            content.sound = UNNotificationSound.default
        }
        
        if let number = Int(model.badge) {
            content.badge = NSNumber(value: number)
        }
        
        let identifier = UUID().uuidString
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger)
        
        try await center.add(request)
        
    }

    func scheduleNotification(date: Date, shortcut: Shortcut) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let content = UNMutableNotificationContent()
        let title = shortcut.title.trimmingCharacters(in: .whitespacesAndNewlines)
        
        content.title = title
        content.body = "This is a repeating reminder."
        let identifier = UUID().uuidString
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        center.add(request)
    }

}

extension NotificationService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.banner, .badge, .sound]
    }
}


class CommonFieldsModel: ObservableObject {
  @Published var title = ""
  @Published var badge = ""
  @Published var isRepeating = false
  @Published var hasSound = false

  func reset() {
    title = ""
    badge = ""
    isRepeating = false
    hasSound = false
  }
}
