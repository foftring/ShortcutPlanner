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
    @Binding var cards: [Card]

        var body: some View {
            List {
                ForEach(cards) { card in
                    Text(card.title)
                }
                .onMove(perform: move)
                .onLongPressGesture {
                    withAnimation {
                        self.isEditable = true
                    }
                }
            }
            .environment(\.editMode, isEditable ? .constant(.active) : .constant(.inactive))
        }

        func move(from source: IndexSet, to destination: Int) {
            cards.move(fromOffsets: source, toOffset: destination)
            withAnimation {
                isEditable = false
            }
        }
}

struct DragRelocateDelegate: DropDelegate {
    let item: Card
    @Binding var listData: [Card]
    @Binding var current: Card?

    func dropEntered(info: DropInfo) {
        if item != current {
            let from = listData.firstIndex(of: current!)!
            let to = listData.firstIndex(of: item)!
            if listData[to].id != current!.id {
                listData.move(fromOffsets: IndexSet(integer: from),
                    toOffset: to > from ? to + 1 : to)
            }
        }
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }

    func performDrop(info: DropInfo) -> Bool {
        self.current = nil
        return true
    }
}

//MARK: - GridItem

struct GridItemView: View {
    var card: Card

    var body: some View {
        VStack {
            Text(card.title)
                .font(.headline)
                .foregroundColor(.white)
        }
        .frame(width: 160, height: 240)
        .background(Color.green)
    }
}

struct DropOutsideDelegate: DropDelegate {
    @Binding var current: Card?
        
    func performDrop(info: DropInfo) -> Bool {
        current = nil
        return true
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView(cards: .constant(dev.cards))
    }
}
