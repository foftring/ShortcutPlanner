//
//  ShortcutPlannerApp.swift
//  ShortcutPlanner
//
//  Created by Frank Oftring on 12/3/22.
//

import SwiftUI

@main
struct ShortcutPlannerApp: App {
    
    @State var deeplinkTarget: DeeplinkManager.DeeplinkTarget?
    
    var body: some Scene {
        WindowGroup {
            Group{
                switch self.deeplinkTarget {
                case .home:
                    TabController()
                case .settings(let queryInfo):
                    ImportShortcutsView()
                case .none:
                    TabController()
                }
            }
                .onOpenURL { url in
                    let deeplinkManager = DeeplinkManager()
                    let deeplink = deeplinkManager.manage(url: url)
                    self.deeplinkTarget = deeplink
                }
        }
    }
}

class DeeplinkManager {
    
    enum DeeplinkTarget: Equatable {
        case home
        case settings(reference: String)
    }
    
    class DeepLinkConstants {
        static let scheme = "shortcutplanner"
        static let host = "com.shortcutplanner"
        static let detailsPath = "/details"
        static let query = "id"
    }
    
    func manage(url: URL) -> DeeplinkTarget {
        guard url.scheme == DeepLinkConstants.scheme,
              url.host == DeepLinkConstants.host,
              url.path == DeepLinkConstants.detailsPath,
              let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems
        else { return .home }
        
        let query = queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
        
        guard let id = query[DeepLinkConstants.query] else { return .home }
        
        return .settings(reference: id)
    }
}
