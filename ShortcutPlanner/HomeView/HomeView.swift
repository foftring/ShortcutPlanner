//
//  ContentView.swift
//  ShortcutPlanner
//
//  Created by Frank Oftring on 12/3/22.
//

import SwiftUI
import Combine

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    @State var background: Color = .clear
    
    var body: some View {
        NavigationView {
            ZStack {
                    background
                    ForEach(viewModel.cards) { card in
                        CardView(offset: $viewModel.offset, card: card)
                            .gesture(DragGesture()
                                .onChanged { gesture in
                                    // Update the position of the top CardView
                                    viewModel.offset = gesture.translation
                                    if gesture.translation.width < -100 { background = .red }
                                    else if gesture.translation.width > 100 { background = .green }
                                    else { background = .clear }
                                    
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
                                        viewModel.runShortcut(card)
                                    } else {
                                        viewModel.offset = .zero
                                        background = .clear
                                    }
                                }
                            )
                    }
                    .navigationTitle("Today")
            }
            .toolbar {
                NavigationLink {
                    ScheduleView(cards: $viewModel.cards)
                } label: {
                    Image(systemName: "menucard.fill")
                }

            }
        }
    }
}



struct Card: Identifiable, Equatable {
    let title: String
    let id = UUID()
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
