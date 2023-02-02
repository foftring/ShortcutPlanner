//
//  NotificationView.swift
//  ShortcutPlanner
//
//  Created by Frank Oftring on 2/2/23.
//

import SwiftUI
import CoreLocation

struct NotificationView: View {
    
    @StateObject var notificationService = NotificationService.shared
    
    var body: some View {
        VStack {
            if !notificationService.authorized {
                Text("This app only works when notifications are enabled.")
            } else {
                List {
                    Section(header: Text("Pending")) {
                        ForEach(notificationService.pending, id: \.identifier) {
                            HistoryCell(for: $0)
                        }
                        .onDelete(perform: deletePendingNotification)
                    }
                }
                .listStyle(GroupedListStyle())
                
            }
        }
        .task {
            await notificationService.refreshNotifications()
        }
    }
    private func deletePendingNotification(at offsets: IndexSet) {
        let identifiers = offsets.map {
            notificationService.pending[$0].identifier
        }
        
        Task {
            await notificationService.removePendingNotifications(identifiers: identifiers)
        }
    }
    
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}

struct HistoryCell: View {
    let trigger: UNNotificationTrigger?
    let content: UNNotificationContent
    
    init(for request: UNNotificationRequest) {
        trigger = request.trigger
        content = request.content
    }
    
    var body: some View {
        switch trigger {
        case let trigger as UNCalendarNotificationTrigger:
            CalendarCell(for: trigger, with: content)
        default:
            Text("Unknown trigger type.")
        }
    }
}

struct CalendarCell: View {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
    
    private let title: String
    private let when: String
    
    init(for trigger: UNCalendarNotificationTrigger, with content: UNNotificationContent) {
        title = "Calendar - \(content.title)"
        
        let prefix = trigger.repeats ? "Every " : ""
        guard let date = Calendar.current.date(from: trigger.dateComponents) else {
            when = "Unknown"
            return
        }
        when = "\(prefix) \(Self.dateFormatter.string(from: date))"
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            
            Text(when)
                .font(.subheadline)
        }
    }
}
