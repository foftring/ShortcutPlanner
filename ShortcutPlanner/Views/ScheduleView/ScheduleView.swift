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

    @FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \ShortcutEntity.order, ascending: true)],
            animation: .default)
        private var items: FetchedResults<ShortcutEntity>
    
    var body: some View {
        List {
            ForEach(shortcuts) { shortcut in
                HStack {
//                    Text("\(shortcuts.firstIndex(of: shortcut)")
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
            .onMove(perform: moveItem)
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
    
    private func moveItem(at sets:IndexSet, destination:Int) {
        let itemToMove = sets.first!
        
        if itemToMove < destination {
            var startIndex = itemToMove + 1
            let endIndex = destination - 1
            var startOrder = items[itemToMove].order
            while startIndex <= endIndex{
                items[startIndex].order = startOrder
                startOrder = startOrder + 1
                startIndex = startIndex + 1
            }
            items[itemToMove].order = startOrder
        }
        else if destination < itemToMove {
            var startIndex = destination
            let endIndex = itemToMove - 1
            var startOrder = items[destination].order + 1
            let newOrder = items[destination].order
            while startIndex <= endIndex{
                items[startIndex].order = startOrder
                startOrder = startOrder + 1
                startIndex = startIndex + 1
            }
            items[itemToMove].order = newOrder
        }
        
        CoreDataService.shared.applyChanges()
        
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
