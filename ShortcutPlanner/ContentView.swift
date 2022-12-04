//
//  ContentView.swift
//  ShortcutPlanner
//
//  Created by Frank Oftring on 12/3/22.
//

import SwiftUI
import Combine

struct CardView: View {
    
    @Binding var offset: CGSize
    let card: String
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .frame(width: 300, height: 200)
                .shadow(color: Color.gray.opacity(0.2), radius: 10, x: 0, y: 20)
                .shadow(color: Color.gray.opacity(0.7), radius: 10, x: 0, y: 5)
            
            Text(card)
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0))
        .offset(x: offset.width, y: offset.height)
    }
}

class ViewModel: ObservableObject {
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

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    @State var background: Color = .clear
    
    var body: some View {
        ZStack {
            background
            ForEach(viewModel.cards) { card in
                CardView(offset: $viewModel.offset, card: card.title)
                    .gesture(DragGesture()
                        .onChanged { gesture in
                            // Update the position of the top CardView
                            viewModel.offset = gesture.translation
                            if gesture.translation.width < -100 { background = .red }
                            else if gesture.translation.width > 100 { background = .green }
                            else {
                                background = .clear
                            }
                            
                        }
                        .onEnded { gesture in
                            if gesture.translation.width < -100 {
                                // Handle swipe left gesture
                                viewModel.removeCard(card: card)
                                print("Removing Card! -100")
                                viewModel.offset = .zero
                                background = .clear
                            } else if gesture.translation.width > 100 {
                                // Handle swipe right gesture
                                viewModel.removeCard(card: card)
                                print("Removing Card! +100")
                                viewModel.offset = .zero
                                background = .clear
                            } else {
                                viewModel.offset = .zero
                                background = .clear
                            }
                        }
                    )
            }
        }
    }
}



struct Card: Identifiable {
    let title: String
    let id = UUID()
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
