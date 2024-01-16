//
//  SeoulGoApp.swift
//  SeoulGo
//
//  Created by kaikim on 12/30/23.
//

import SwiftUI

@main
struct SeoulGoApp: App {

    @StateObject private var network = Network()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(network)
                .onOpenURL(perform: { url in
                    let text = url.absoluteString.removingPercentEncoding ?? ""
                })
        }
 
    }
}
