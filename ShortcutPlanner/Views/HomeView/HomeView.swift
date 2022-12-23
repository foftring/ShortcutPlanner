//
//  ContentView.swift
//  ShortcutPlanner
//
//  Created by Frank Oftring on 12/3/22.
//

import SwiftUI
import Combine
import SafariServices

struct HomeView: View {
    @Environment(\.scenePhase) var scenePhase
    @StateObject var viewModel = HomeViewModel()
    @State var background: Color = .clear
    @State private var showSafari: Bool = false
    let test: [Int] = []
    
    var body: some View {
        NavigationView {
            ZStack {
                
                if viewModel.shortcuts.isEmpty {
                    SwipeBotButton(text: "Tap to import shortcuts", foregroundColor: .primary, fillColor: .green)
                        .onTapGesture {
                            showSafari = true
                        }
                }
                
                 else if viewModel.isFinished {
                    VStack(spacing: 20) {
                        Text("No messages found")
                            .font(.title)
                        Text("Seems like you are all caught up for now")
                            .font(.title3)
                        Image("inbox")
                    }
                }
                background
                    .edgesIgnoringSafeArea(.all)
                ForEach(viewModel.shortcuts.filter({ !$0.isComplete })) { shortcut in
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
                                    viewModel.updateShortcut(shortcut, shouldToggle: true)
                                    print("Removing Card! -100")
                                    viewModel.offset = .zero
                                    background = .clear
                                } else if gesture.translation.width > 100 {
                                    // Handle swipe right gesture
                                    viewModel.updateShortcut(shortcut, shouldToggle: true)
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
                    ScheduleView(shortcuts: $viewModel.shortcuts, viewModel: viewModel)
                } label: {
                    Image(systemName: "menucard.fill")
                        .renderingMode(.original)
                        .tint(.primary)
                }
                
                Button {
                    viewModel.resetCoreData()
                } label: {
                    Text("Reset")
                        .foregroundColor(.primary)
                }
                
            }
            .sheet(isPresented: $showSafari, content: {
                SFSafariViewWrapper(url: URL(string: "https://www.icloud.com/shortcuts/d2521bc53946416eb560e10966f70c1d")!)
            })
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .background {
                    showSafari = false
                }
            }
            .onAppear {
                viewModel.resetAppValuesIfNewDay()
            }
        }
    }
}

struct SwipeBotButton: View {
    
    let text: String
    let foregroundColor: Color
    let fillColor: Color
    
    var body: some View {
        Text(text)
            .foregroundColor(foregroundColor)
            .padding()
            .frame(minWidth: 147, minHeight: 52)
            .background(
                RoundedRectangle(cornerRadius: 34, style: .continuous)
                    .fill(fillColor)
            )
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


struct SFSafariViewWrapper: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SFSafariViewWrapper>) {
        return
    }
}
