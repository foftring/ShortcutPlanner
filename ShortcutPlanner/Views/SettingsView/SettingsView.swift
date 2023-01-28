//
//  SettingsView.swift
//  ShortcutPlanner
//
//  Created by Frank Oftring on 12/22/22.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var linkManager: DeeplinkManager
    var body: some View {
        NavigationView {
            List {
                Section {
                    Text("Notifications")
                    Button {
                        linkManager.activeTab = .importView
                    } label: {
                        HStack {
                            Image(systemName: "square.and.arrow.down.fill")
                                .foregroundColor(.primary)
                            Text("Import")
                                .foregroundColor(.primary)
                        }
                    }
                }
                
                Section {
                    Text("About")
                    Text("Request a Feature")
                    Text("What's New")
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
