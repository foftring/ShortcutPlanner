//
//  TabController.swift
//  ShortcutPlanner
//
//  Created by Frank Oftring on 12/20/22.
//

import SwiftUI

class TabViewModel: ObservableObject {
    @Published var shortcuts: [String] = []
    @Published var selction: TabType = .home
    let dataStore = ShortcutStore.shared
}

struct TabController: View {
    
    @EnvironmentObject var linkManager: DeeplinkManager
    @StateObject var viewModel = TabViewModel()
    
    var body: some View {
        TabView(selection: $linkManager.activeTab) {
            HomeView()
                .tag(TabType.home)
                .tabItem {
                    Text("Schedule")
                        .accentColor(.red)
                    Image(systemName: "tray.fill")
                        .renderingMode(.original)
                }
            
            SettingsView()
                .tag(TabType.settings)
                .tabItem {
                    Text("Settings")
                    Image(systemName: "gear.circle.fill")
                        .renderingMode(.original)
                }
            
            ImportShortcutsView()
                .tag(TabType.importView)
        }
        .tint(.primary)
    }
}

struct TabController_Previews: PreviewProvider {
    static var previews: some View {
        TabController()
    }
}
