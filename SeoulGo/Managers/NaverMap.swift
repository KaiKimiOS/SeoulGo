//
//  NaverMap.swift
//  SeoulGo
//
//  Created by kaikim on 1/9/24.
//

import SwiftUI
import NMapsMap

struct NaverMap: UIViewRepresentable{
    
    var x: Double
    var y: Double
    
    func makeCoordinator() -> Coordinator {
        Coordinator.shared
    }
    
    func makeUIView(context: Context) -> some NMFMapView {
        context.coordinator.getNaverMap(x: x, y: y)
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}


/// Delegate를 사용해서 객체를 한번만 사용하기
/// Coordinator 클래스를 사용하여 NMFMapView 객체를 공유함으로써 메모리 효율성이 좋아졌다.
/// 이전과 비교해서 앱 실행 중에 여러 NaverMap뷰가 생성되어도 단일 객체(Coordinator.shared)만 사용되기 때문입니다.
/// 단, Coordinator 클래스가 싱글톤 객체이므로 스레드 간의 안전성에 주의하기 -> weak 사용하기.
/// 이전 코드의 단점: 매번 새로운 NMFMapView 객체를 생성하기 때문에 메모리 사용량이 많습니다. 여러 NaverMap뷰가 생성되는 경우 메모리 부족 문제가 발생할 수 있습니다.

class Coordinator : NSObject,ObservableObject{
    
    static let shared = Coordinator()
    
    let view = NMFMapView()
    let marker = NMFMarker()
    
    func getNaverMap(x:Double, y:Double) -> NMFMapView {
        let location = NMGLatLng(lat: y, lng: x)
        view.moveCamera( (NMFCameraUpdate(scrollTo: location)))
        
        view.zoomLevel = 15
        view.allowsZooming = true
        view.isZoomGestureEnabled =  true
        view.isScrollGestureEnabled =  true
        
        marker.position = location
        marker.mapView = view
        return view
    }
    
}


//개선 전 코드
/*
struct NaverMap: UIViewRepresentable{
   
  var y:Double
  var x:Double
   
  func updateUIView(_ uiView: UIViewType, context: Context) {
     
  }
   
  
  func makeUIView(context: Context) -> some NMFNaverMapView {
    let view = NMFNaverMapView()
    view.showZoomControls = false
    view.mapView.positionMode = .direction
    view.mapView.zoomLevel = 17
  func makeUIView(context: Context) -> some NMFMapView {
    let view = NMFMapView()
    let marker = NMFMarker()
    let temp = NMGLatLng(lat: y, lng: x)
    marker.position = temp
    
    marker.mapView = view
    view.isScrollGestureEnabled = true
    view.moveCamera( (NMFCameraUpdate(scrollTo: temp)))

    return view
  }

}
*/

