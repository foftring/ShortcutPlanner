//
//  SettingsView.swift
//  ShortcutPlanner
//
//  Created by Frank Oftring on 12/22/22.
//

import SwiftUI

struct SettingsView: View {
    @State private var isShowingImportView: Bool = false
    var body: some View {
        NavigationView {
            List {
                Section {
                    Text("Notifications")
                    Button {
                        isShowingImportView = true
                    } label: {
                        HStack {
                            Image(systemName: "square.and.arrow.down.fill")
                                .foregroundColor(.primary)
                            Text("Import")
                                .foregroundColor(.primary)
                        }
                    }
                    
                    NavigationLink("Import Shortcuts") {
                        ImportShortcutsView()
                    }
                }
                
                Section {
                    Text("About")
                    Text("Request a Feature")
                    Text("What's New")
                }
            }
            .sheet(isPresented: $isShowingImportView) {
                ImportShortcutsView()
        }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
