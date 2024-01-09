//
//  NaverMap.swift
//  SeoulGo
//
//  Created by kaikim on 1/9/24.
//

import SwiftUI
import NMapsMap
import UIKit

struct NaverMap: UIViewRepresentable{
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
   
    func makeUIView(context: Context) -> some NMFNaverMapView {
        let view = NMFNaverMapView()
        view.showZoomControls =  false
        view.mapView.positionMode = .direction
        view.mapView.zoomLevel = 17
        return view
    }
    
    

}

#Preview {
    NaverMap()
}
