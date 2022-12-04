//
//  HomeViewModel.swift
//  ShortcutPlanner
//
//  Created by Frank Oftring on 12/3/22.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var offset: CGSize = .zero
    @Published var cards: [Card] = []
    var cancellables = Set<AnyCancellable>()
    
    init() {
        getCards()
        addSubscribers()
    }
    
    func getCards() {
        for index in 0..<10 {
            cards.append(Card(title: "Card: #\(index)"))
        }
    }
    
    func addSubscribers() {
        $offset
            .sink { offest in
                print("Offset -- \(offest)")
            }
            .store(in: &cancellables)
    }
    
    func removeCard(card: Card) {
        if let index = cards.firstIndex(where: { $0.title == card.title }) {
            cards.remove(at: index)
        }
    }
}
