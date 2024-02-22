//
//  SeoulGoApp.swift
//  SeoulGo
//
//  Created by kaikim on 12/30/23.
//

import SwiftUI
import GoogleMobileAds
import AppTrackingTransparency
@main
struct SeoulGoApp: App {
    
    @StateObject private var store = Store()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .onOpenURL(perform: { url in
                    let text = url.absoluteString.removingPercentEncoding ?? ""
                })
        }
 
    }
    init() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            AppTrackingTransparency.ATTrackingManager.requestTrackingAuthorization { _ in            }
        }
    }
}
