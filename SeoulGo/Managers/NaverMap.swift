//
//  NaverMap.swift
//  SeoulGo
//
//  Created by kaikim on 1/9/24.
//

import SwiftUI
import NMapsMap


struct NaverMap: UIViewRepresentable{
    
    var y:Double
    var x:Double
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    func makeUIView(context: Context) -> some NMFMapView {
        let nmapShared = NMFMapView()
        let marker = NMFMarker()
        let temp = NMGLatLng(lat: y, lng: x)
        marker.position = temp
        nmapShared.zoomLevel = 15
        nmapShared.allowsZooming = true
        nmapShared.isZoomGestureEnabled = true
        
        marker.mapView = nmapShared
        nmapShared.isScrollGestureEnabled = true
        nmapShared.moveCamera( (NMFCameraUpdate(scrollTo: temp)))

        return nmapShared
    }

}


