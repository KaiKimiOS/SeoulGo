//
//  BannerView.swift
//  SeoulGo
//
//  Created by kaikim on 2/22/24.
//

import SwiftUI
import GoogleMobileAds

struct BannerView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = UIViewController()
        let bannerSize = GADPortraitInlineAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.width)
        let view = GADBannerView(adSize: bannerSize)
        view.adUnitID = "ca-app-pub-3940256099942544/2934735716" // test Key
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: bannerSize.size)
        view.load(GADRequest())
        return viewController
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    
    }
}
