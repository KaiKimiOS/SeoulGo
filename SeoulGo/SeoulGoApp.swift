//
//  SeoulGoApp.swift
//  SeoulGo
//
//  Created by kaikim on 12/30/23.
//

import SwiftUI


@main
struct SeoulGoApp: App {
    
    @StateObject private var store = Store()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    if store.finalInformation.isEmpty {
                        await store.fetchRequest()
                    }
                }
                .environmentObject(store)
                .onOpenURL(perform: { url in
                    let text = url.absoluteString.removingPercentEncoding ?? ""
                })
        }
 
    }
}
