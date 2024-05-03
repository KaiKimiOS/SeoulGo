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
        view.adUnitID = Bundle.main.infoDictionary?["GoogleBannerID"] as? String// test Key
        view.load(GADRequest())
        return view
    }
  
    func updateUIView(_ uiViewController: GADBannerView, context: Context) {
        
    }
}
