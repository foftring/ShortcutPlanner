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
                    .edgesIgnoringSafeArea(.all)
                    ForEach(viewModel.shortcuts) { shortcut in
                        CardView(offset: $viewModel.offset, shortcut: shortcut)
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
                                        viewModel.removeCard(shortcut: shortcut)
                                        print("Removing Card! -100")
                                        viewModel.offset = .zero
                                        background = .clear
                                    } else if gesture.translation.width > 100 {
                                        // Handle swipe right gesture
                                        viewModel.removeCard(shortcut: shortcut)
                                        print("Removing Card! +100")
                                        viewModel.offset = .zero
                                        background = .clear
                                        viewModel.runShortcut(shortcut)
                                    } else {
                                        viewModel.offset = .zero
                                        background = .clear
                                    }
                                }
                            )
                    }
                    .navigationTitle("My Shortcuts")
            }
            .toolbar {
                NavigationLink {
                    ScheduleView(shortcuts: $viewModel.shortcuts)
                } label: {
                    Image(systemName: "menucard.fill")
                        .renderingMode(.original)
                        .tint(.primary)
                }
                
                Button {
                    viewModel.resetAppValuesIfNewDay()
                } label: {
                    Text("Reset")
                }

            }
            .onAppear {
                viewModel.resetAppValuesIfNewDay()
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
