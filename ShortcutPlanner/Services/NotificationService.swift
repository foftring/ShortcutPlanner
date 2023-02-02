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
    
    let categoryIdentifier = "AcceptOrReject"
    
    public enum ActionIdentifier: String {
        case accept, reject
    }
    
    
    func requestAuthorization() async throws {
        authorized = try await center.requestAuthorization(options: [.badge, .sound, .alert])
        self.registerCustomActions()
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
    
    func scheduleNotification(date: Date, shortcut: Shortcut) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = categoryIdentifier
        let title = shortcut.title.trimmingCharacters(in: .whitespacesAndNewlines)
        
        content.title = title
        content.body = "It's time to run your shortcut"
        let identifier = UUID().uuidString
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        center.add(request)
    }
    
    func registerCustomActions() {
        let accept = UNNotificationAction(identifier: ActionIdentifier.accept.rawValue, title: "Accept")
        let reject = UNNotificationAction(identifier: ActionIdentifier.reject.rawValue, title: "Reject")
        let category = UNNotificationCategory(identifier: categoryIdentifier, actions: [accept, reject], intentIdentifiers: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
    
    
    
    
}

extension NotificationService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.banner, .badge, .sound]
    }
    
    @MainActor
    internal func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
      let identity = response.notification.request.content.categoryIdentifier
      guard identity == categoryIdentifier, let action = ActionIdentifier(rawValue: response.actionIdentifier) else { return }
      print("You pressed \(response.actionIdentifier)")
        switch action {
        case .accept:
            print("running accept action")
        case .reject:
            print("running reject action")
        }
    }

}
