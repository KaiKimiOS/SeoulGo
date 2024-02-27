//
//  BannerView.swift
//  SeoulGo
//
//  Created by kaikim on 2/22/24.
//

import SwiftUI
import GoogleMobileAds

struct BannerView: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    func makeUIView(context: Context) -> GADBannerView {
        
        let view = GADBannerView(adSize: GADAdSizeBanner)
        view.adUnitID = "ca-app-pub-3940256099942544/2934735716" // test Key
        view.rootViewController = UIApplication.shared.getRootViewController()
        view.delegate =  context.coordinator
        view.load(GADRequest())
        return view
    }
 
    func updateUIView(_ uiViewController: GADBannerView, context: Context) {
    
    }
    
    class Coordinator:NSObject, GADBannerViewDelegate {
        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
          print("bannerViewDidReceiveAd")
        }

        func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
          print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
        }

        func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
          print("bannerViewDidRecordImpression")
        }

        func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
          print("bannerViewWillPresentScreen")
        }

        func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
          print("bannerViewWillDIsmissScreen")
        }

        func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
          print("bannerViewDidDismissScreen")
        }
    }
}


extension UIApplication {
    
    func getRootViewController() -> UIViewController {
        
        guard let screen = self.connectedScenes.first as? UIWindowScene  else { return .init() }
        
        guard let root = screen.windows.first?.rootViewController else { return .init()}
        
        return root
    }
}


struct BannerViewView:View {
    var body: some View {
        BannerView()
    }
}
