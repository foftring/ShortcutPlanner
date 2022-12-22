//
//  TabController.swift
//  ShortcutPlanner
//
//  Created by Frank Oftring on 12/20/22.
//

import SwiftUI

struct TabController: View {
    
    @State var shortcuts: [String] = []
    @State var selction: Int = 1
    let dataStore = ShortcutStore.shared
    
    
    var body: some View {
        TabView(selection: $selction) {
            
            HomeView()
                .tag(1)
                .tabItem {
                    Text("Schedule")
                        .accentColor(.red)
                    Image(systemName: "tray.fill")
                        .renderingMode(.original)
                }
            
            SettingsView(selection: $selction)
                .tag(2)
                .tabItem {
                    Text("Settings")
                    Image(systemName: "gear.circle.fill")
                        .renderingMode(.original)
                }
            
        }
        .tint(.primary)
    }
}

struct TabController_Previews: PreviewProvider {
    static var previews: some View {
        TabController()
    }
}
