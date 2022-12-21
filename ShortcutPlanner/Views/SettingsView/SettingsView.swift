//
//  SettingsView.swift
//  ShortcutPlanner
//
//  Created by Frank Oftring on 12/20/22.
//

import SwiftUI

struct SettingsView: View {
    
    @State var textEditText: String = ""
    @Binding var selection: Int
    
    let dataStore = ShortcutStore.shared
    
    var body: some View {
        Form {
            Button {
                parseShortcuts()
            } label: {
                Text("Import Shortcuts")
            }
            Section("Paste shortcuts here") {
                TextEditor(text: $textEditText)
                    .frame(height: 350)
            }
            .toolbar {
                Button {
                    
                } label: {
                    
                }

            }
        }
    }
    
    func parseShortcuts() {
        let parsedString = textEditText.split(whereSeparator: \.isNewline)
        let mapped = parsedString.map { String($0 )}
        print("mapped shortcuts: \(mapped)")
        dataStore.shortcuts = mapped
        selection = 1
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(selection: .constant(2))
    }
}
