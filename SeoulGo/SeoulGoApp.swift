//
//  SeoulGoApp.swift
//  SeoulGo
//
//  Created by kaikim on 12/30/23.
//

import SwiftUI
import AppTrackingTransparency

@main
struct SeoulGoApp: App {
    
    @StateObject private var store = Store()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in })
                        }
                .task {
                    await store.fetchRequest()
                }
                .environmentObject(store)
                .onOpenURL(perform: { url in
                    let text = url.absoluteString.removingPercentEncoding ?? ""
                })
        }
        
    }
}
