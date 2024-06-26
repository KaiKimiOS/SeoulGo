//
//  NaverMap.swift
//  SeoulGo
//
//  Created by kaikim on 1/9/24.
//

import SwiftUI
import NMapsMap

struct NaverMapWithSnapShot: UIViewRepresentable{
    
    var x: Double
    var y: Double
    
    func makeUIView(context: Context) -> some NMFMapView {
        
        let map = NMFMapView()
        let marker = NMFMarker()
        let location = NMGLatLng(lat: y, lng: x)
        map.moveCamera( (NMFCameraUpdate(scrollTo: location)))
        map.zoomLevel = 14
        map.allowsZooming = false
//        map.isZoomGestureEnabled =  false
        map.isScrollGestureEnabled =  false
        marker.position = location
        marker.mapView = map
        
        return map
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}

struct NaverMapWithNavigationLink: UIViewRepresentable{
    
    var x: Double
    var y: Double
    
    func makeUIView(context: Context) -> some NMFMapView {
        
        let map = NMFMapView()
        
        let marker = NMFMarker()
        let location = NMGLatLng(lat: y, lng: x)
        map.moveCamera( (NMFCameraUpdate(scrollTo: location)))
        map.zoomLevel = 15
        map.allowsZooming = true
        map.isZoomGestureEnabled =  true
        map.isScrollGestureEnabled =  true
        marker.position = location
        marker.mapView = map
        
        return map
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}


/// Delegate를 사용해서 객체를 한번만 사용하기
/// Coordinator 클래스를 사용하여 NMFMapView 객체를 공유함으로써 메모리 효율성이 좋아졌다.
/// 이전과 비교해서 앱 실행 중에 여러 NaverMap뷰가 생성되어도 단일 객체(Coordinator.shared)만 사용되기 때문입니다.
/// 단, Coordinator 클래스가 싱글톤 객체이므로 스레드 간의 안전성에 주의하기 -> weak 사용하기.
/// 이전 코드의 단점: 매번 새로운 NMFMapView 객체를 생성하기 때문에 메모리 사용량이 많습니다. 여러 NaverMap뷰가 생성되는 경우 메모리 부족 문제가 발생할 수 있습니다.
