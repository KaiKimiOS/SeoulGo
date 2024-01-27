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
        let view = NMFMapView()
        let marker = NMFMarker()
        let temp = NMGLatLng(lat: y, lng: x)
        marker.position = temp
        view.zoomLevel = 15
        view.allowsZooming = true
        view.isZoomGestureEnabled = true
        
        marker.mapView = view
        view.isScrollGestureEnabled = true
        view.moveCamera( (NMFCameraUpdate(scrollTo: temp)))

        return view
    }

}


