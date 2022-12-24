//
//  SettingsView.swift
//  ShortcutPlanner
//
//  Created by Frank Oftring on 12/20/22.
//

import SwiftUI

struct ImportShortcutsView: View {
    
    @State var isShowingInstructionsView: Bool = false
    @State var textEditText: String = ""
    
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
        }
        .onAppear {
            getPasteboard()
        }
        .sheet(isPresented: $isShowingInstructionsView) {
            VStack(alignment: .center) {
                Text("1. Install or run the shortcut found here:")
                Link("Get all shortcuts", destination: URL(string: "https://succinct-act-6b1.notion.site/Shortcut-Planner-47cc900691f24586adfec1fe5dba1a78")!)
                    .onTapGesture {
                        isShowingInstructionsView = false
                    }
                Text("2. Once shortcuts are copied to clipboard, press 'Import Shortcuts' on the next screen")
            }
            .padding()
        }
    }
    
    func parseShortcuts() {
        let parsedString = textEditText.split(whereSeparator: \.isNewline)
        let shortcuts = parsedString.map {
            let index = parsedString.firstIndex(of: $0) ?? 0
            return Shortcut(id: UUID(), title: String($0), order: (index + 1))
        }
        print("mapped shortcuts: \(shortcuts)")
        for shortcut in shortcuts {
            CoreDataService.shared.add(shortcut: shortcut)
        }
    }
    
    func getPasteboard() {
        // Set string to clipboard
        let pasteboard = UIPasteboard.general
        if let text = pasteboard.string {
            print(text)
            self.textEditText = text
        }
    }
}

struct ImportShortcutsView_Previews: PreviewProvider {
    static var previews: some View {
        ImportShortcutsView()
    }
}
