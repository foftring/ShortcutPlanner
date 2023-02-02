//
//  ShortcutPlannerApp.swift
//  ShortcutPlanner
//
//  Created by Frank Oftring on 12/3/22.
//

import SwiftUI

@main
struct ShortcutPlannerApp: App {
    @StateObject var deeplinkManager = DeeplinkManager()
    let persistenceController = CoreDataService.shared
    
    var body: some Scene {
        WindowGroup {
            TabController()
                .onOpenURL { url in
                    print("url: \(url)")
                     deeplinkManager.manage(url: url)
                }
                .environmentObject(deeplinkManager)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)

        }
    }
}

enum TabType: String, Equatable {
    case home
    case settings
    case importView
}
class DeeplinkManager: ObservableObject {
    
    @Published var activeTab: TabType = .home
    private let scheme = "swipebot"
    
    func manage(url: URL) {
        guard url.scheme == scheme, let host = URLComponents(url: url, resolvingAgainstBaseURL: true)?.host else {
            print("invalid scheme. opening home \(url.scheme)")
            activeTab = .home
            return
        }
        
        if host == TabType.home.rawValue {
            activeTab = .home
        } else if host == TabType.settings.rawValue {
            activeTab = .settings
        } else if host == TabType.importView.rawValue {
            activeTab = .importView
            print("activeTab: \(self.activeTab)")
        } else {
            activeTab = .home
        }
    }
}
