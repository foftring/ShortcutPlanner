//
//  ScheduleView.swift
//  ShortcutPlanner
//
//  Created by Frank Oftring on 12/20/22.
//

import SwiftUI
import UniformTypeIdentifiers

//MARK: - Grid

struct ScheduleView: View {
    @State private var isEditable = false
    @Binding var shortcuts: [Shortcut]
    @ObservedObject var viewModel: HomeViewModel

        var body: some View {
            List {
                ForEach(shortcuts) { shortcut in
                    HStack {
                        Text("\(shortcut.order ?? 0)")
                        Text(shortcut.title)
                            .foregroundColor(shortcut.isComplete ? .secondary : .primary)
                            .strikethrough(shortcut.isComplete)
                        Spacer()
                        if shortcut.isComplete {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                    .onTapGesture {
                        viewModel.updateShortcut(shortcut, shouldToggle: true)
                    }
                }
                .onMove(perform: move)
                .onLongPressGesture {
                    withAnimation {
                        self.isEditable = true
                    }
                }
            }
            .listSectionSeparator(.hidden)
            .listRowSeparator(.hidden)
            .environment(\.editMode, isEditable ? .constant(.active) : .constant(.inactive))
        }

        func move(from source: IndexSet, to destination: Int) {
            shortcuts.move(fromOffsets: source, toOffset: destination)
            for shortcut in shortcuts {
                shortcut.order = destination
            }
            withAnimation {
                isEditable = false
            }
        }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView(shortcuts: .constant(dev.shortcuts), viewModel: HomeViewModel())
    }
}

struct ListRow: View {
    let shortcut: Shortcut
    let index: Int?
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .frame(height: 50)
                .shadow(color: Color.gray.opacity(0.2), radius: 10, x: 0, y: 20)
                .shadow(color: Color.gray.opacity(0.7), radius: 10, x: 0, y: 5)
                .padding()
            
            Text(shortcut.title)
        }
    }
}

struct ListRow_Previews: PreviewProvider {
    static var previews: some View {
        ListRow(shortcut: dev.shotcut, index: 2)
    }
}
