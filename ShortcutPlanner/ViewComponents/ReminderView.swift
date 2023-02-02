//
//  ReminderView.swift
//  ShortcutPlanner
//
//  Created by Frank Oftring on 1/11/23.
//

import SwiftUI

struct ReminderView: View {
    @State var buttonPressed: Bool = false
    @State var showCheckmark: Bool = false
    @Binding var triggerDate: Date
    @Binding var shouldRepeat: Bool
    @Binding var expandView: Bool
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
            
            Button {
                notificationService.scheduleNotification(date: triggerDate, shortcut: shortcut)
            } label: {
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.black)
                            .frame(width: 250, height: 60)
                        
                        Text("Schedule Shortcut")
                            .foregroundColor(.white)
                    }
                    .onTapGesture {
                        buttonPressed = true
                        showCheckmark = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            buttonPressed = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showCheckmark = false
                            expandView.toggle()
                        }
                    }
                    .scaleEffect(buttonPressed ? 1.2 : 1)
                    .animation(.spring(response: 0.4, dampingFraction: 0.6))
                    .padding()
                    
                    if showCheckmark {
                        HStack {
                            Text("Scheduled")
                                .foregroundColor(.green)
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.title)
                            .animation(.easeIn(duration: 1.0))
                        }
                    }
                }
            }
            
        }
        .padding()
    }
}

struct ReminderView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderView(triggerDate: .constant(Date()), shouldRepeat: .constant(true), expandView: .constant(true), shortcut: dev.shotcut)
    }
}
