//
//  NotificationService.swift
//  ShortcutPlanner
//
//  Created by Frank Oftring on 1/11/23.
//

import Foundation
import UserNotifications

class NotificationService: ObservableObject {
    static let shared = NotificationService()
    @Published var settings: UNNotificationSettings?
    
    func requestAuthorization(completion: @escaping  (Bool) -> Void) {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _  in
                self.fetchNotificationSettings()
                completion(granted)
            }
    }
    
    func fetchNotificationSettings() {
        // 1
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            // 2
            DispatchQueue.main.async {
                self.settings = settings
            }
        }
    }
    
    // 1
    func scheduleNotification(shortcut: Shortcut) {
        // 2
        let content = UNMutableNotificationContent()
        content.title = shortcut.title
        content.body = "Gentle reminder for your task!"
        content.categoryIdentifier = "OrganizerPlusCategory"
        let taskData = try? JSONEncoder().encode(shortcut)
        if let taskData = taskData {
            content.userInfo = ["Task": taskData]
        }
        
        // 3
        var trigger: UNNotificationTrigger?
        
        if let date = shortcut.reminder?.date {
            trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: date), repeats: shortcut.reminder?.repeats ?? false)
        }
        
        // 4
        if let trigger = trigger {
            let request = UNNotificationRequest(identifier: shortcut.id.uuidString, content: content, trigger: trigger)
            // 5
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print(error)
                }
            }
        }
    }
    
    func removeScheduledNotification(shortcut: Shortcut) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [shortcut.id.uuidString])
    }
    
    
}
