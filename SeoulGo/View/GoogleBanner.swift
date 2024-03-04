//
//  BannerView.swift
//  SeoulGo
//
//  Created by kaikim on 2/22/24.
//

import SwiftUI
import GoogleMobileAds

struct GoogleBanner: UIViewRepresentable {
    
    func makeUIView(context: Context) -> GADBannerView {
        
        let view = GADBannerView(adSize: GADAdSizeBanner)
        view.adUnitID = "ca-app-pub-3940256099942544/2934735716" // test Key
        view.load(GADRequest())
        return view
    }
 
    func updateUIView(_ uiViewController: GADBannerView, context: Context) {

    }
    
}
