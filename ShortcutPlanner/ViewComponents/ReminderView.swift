//
//  ReminderView.swift
//  ShortcutPlanner
//
//  Created by Frank Oftring on 1/11/23.
//

import SwiftUI

struct ReminderView: View {
    @Binding var triggerDate: Date
    @Binding var shouldRepeat: Bool
    let shortcut: Shortcut
    let notificationService = NotificationService.shared
    
    var body: some View {
        VStack {
                DatePicker("Please enter a date", selection: $triggerDate)
                    .labelsHidden()
                    .padding(.vertical)
            
            Toggle(isOn: $shouldRepeat) {
                Text("Repeat Notification")
            }
            
            Button("Add Notification") {
                notificationService.scheduleNotification(date: triggerDate, shortcut: shortcut)
            }
        }
        .padding()
    }
}

struct ReminderView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderView(triggerDate: .constant(Date()), shouldRepeat: .constant(true), shortcut: dev.shotcut)
    }
}
