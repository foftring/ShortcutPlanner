//
//  TabController.swift
//  ShortcutPlanner
//
//  Created by Frank Oftring on 12/20/22.
//

import SwiftUI

struct TabController: View {
    var body: some View {
        TabView {
            
            HomeView()
                .tabItem {
                    Text("Schedule")
                        .accentColor(.red)
                    Image(systemName: "tray.fill")
                        .renderingMode(.original)
                }
            
            Text("AnotherView!!")
                .tabItem {
                    Text("Second View")
                    Image(systemName: "gear.circle.fill")
                        .renderingMode(.original)
                }
            
        }
        .tint(.red)
    }
}

struct TabController_Previews: PreviewProvider {
    static var previews: some View {
        TabController()
    }
}
