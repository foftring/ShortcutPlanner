//
//  TabController.swift
//  ShortcutPlanner
//
//  Created by Frank Oftring on 12/20/22.
//

import SwiftUI

class TabViewModel: ObservableObject {
    @Published var shortcuts: [String] = []
    @Published var selction: Int = 1
    let dataStore = ShortcutStore.shared
}

struct TabController: View {
    
    @StateObject var viewModel = TabViewModel()
    
    var body: some View {
        TabView(selection: $viewModel.selction) {
            
            HomeView()
                .tag(1)
                .tabItem {
                    Text("Schedule")
                        .accentColor(.red)
                    Image(systemName: "tray.fill")
                        .renderingMode(.original)
                }
            
            SettingsView()
                .tag(2)
                .tabItem {
                    Text("Settings")
                    Image(systemName: "gear.circle.fill")
                        .renderingMode(.original)
                }
            
            ImportShortcutsView()
                .tag(3)
        }
        .environmentObject(viewModel)
        .tint(.primary)
    }
}

struct TabController_Previews: PreviewProvider {
    static var previews: some View {
        TabController()
    }
}
