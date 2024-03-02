//
//  DetailView.swift
//  SeoulGo
//
//  Created by kaikim on 1/9/24.
//

import SwiftUI
import NMapsMap
import WebKit
import SafariServices
import WidgetKit
import GoogleMobileAds

struct DetailView:View {
    @State var starBool:Bool = false
    @State var isWebViewBool: Bool = false
    @State var isNaverMapBool:Bool = false
    @State var isAlertBool:Bool = false
    @StateObject var coordinator : Coordinator = Coordinator.shared
    
    
    var information:Row
    
    var imageURL: URL? {
        URL(string: information.imageURL)
    }
    
    var locationY: Double {
        get{
            guard let locationY = Double(information.locationY) else { return 0 }
            return locationY
        }
        
    }
    
    var locationX: Double {
        get{
            guard let locationX = Double(information.locationX) else { return 0 }
            return locationX
        }
        
    }
    
    var star:String {
        
        starBool ? "star.fill" : "star"
        
    }
    
    var body: some View {
        ScrollView(showsIndicators: false){
            
            VStack{
                
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .frame(maxWidth: .infinity, minHeight: 182, idealHeight: 182, maxHeight: 182)
                    //.aspectRatio(16/9, contentMode: .fit)
                    
                } placeholder: {
                    ProgressView()
                }
            }
            VStack(alignment:.leading,spacing: 10){
                
                MainTitleView()
                ButtonView()
                VStack {
                    ZStack(alignment:.topTrailing) {
                        
                        
                        if isNaverMapBool {
                            NaverMapWithSnapShot(x: locationX, y: locationY)
                                .frame(maxWidth: .infinity, minHeight: 162)
                            
                        }
                        NavigationLink{
                            
                            NaverMapWithNavigationLink(x: locationX, y: locationY)
                        } label: {
                            Image(systemName: "arrow.down.backward.and.arrow.up.forward.square.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundStyle(Color.gray.opacity(0.5))
                                .frame(width: 30, height: 30)
                                .padding(10)
                            
                        }
                    }
                    
                }
                
                
                HStack(spacing: 15) {
                    Text("주소      ")
                    Text("\(information.areaName)" + " - \(information.placeName)" )
                    
                }
                .modifier(detailMoidifier())
                
                HStack(spacing: 15){
                    Text("접수상태")
                    Text("\(information.serviceStatus)" + "(\(information.payment))")
                    
                }
                .modifier(detailMoidifier())
                
                HStack(spacing: 15){
                    
                    Text("접수기간")
                    Text("\(information.registerStartDate)" + " ~ \(information.registerEndDate)" )
                    
                }
                .modifier(detailMoidifier())
                
                if information.telephone != "" {
                    HStack(spacing: 15){
                        Text("전화번호")
                        Text("\(information.telephone)")
                            .foregroundStyle(.blue)
                            .onTapGesture {
                                makePhoneCall()
                            }
                    }
                    .modifier(detailMoidifier())
                }
                
                HStack(alignment:.center){
                    Spacer()
                    BannerView()
                        .frame(width: 320, height: 50)
                    Spacer()
                }
                .modifier(detailMoidifier())
            }
            .padding()
            .sheet(isPresented: $isWebViewBool, content: {
                SFSafariView(url: information.informationURL)
            })
            
            .alert(starBool ? "저장되었습니다" : "저장이 취소되었습니다", isPresented: $isAlertBool, actions: {
                VStack{
                    Text("확인")
                }
            })
            
            .onAppear {
                
                isNaverMapBool = true
                if UserDefaults.shared.value(forKey: "\(information.serviceID)") as? String ?? "" == information.serviceID {
                    
                    starBool = true
                } else {
                    starBool = false
                }
                
            }
            
            .onDisappear {
                isNaverMapBool = false
            }
        }
        
        
        
    }
    @ViewBuilder
    func MainTitleView() -> some View {
        VStack(alignment: .center){
            Text("\(information.serviceName)")
                .bold()
                .lineLimit(1)
                .frame(maxWidth:.infinity)
                .font(.system(size: 18, weight: .bold, design: .default ))
                .padding(.bottom)
            Divider()
        }
        //        .border(.blue)
    }
    @ViewBuilder
    func ButtonView() -> some View {
        HStack {
            VStack{
                
                Button {
                    isWebViewBool = true
                } label: {
                    VStack(spacing: 5){
                        Image(systemName: "calendar")
                        
                        Text("예약 사이트")
                    }
                    
                }
            }
            .frame(maxWidth: .infinity)
            //            .border(.black)
            Divider()
                .frame(height: 64)
            VStack{
                Button {
                    starBool.toggle()
                    starBool ?  UserDefaults.shared.setValue(information.serviceID, forKey: information.serviceID) :
                    UserDefaults.shared.removeObject(forKey: information.serviceID)
                    WidgetCenter.shared.reloadAllTimelines()
                    isAlertBool.toggle()
                } label: {
                    VStack(spacing: 5){
                        Image(systemName: star)
                        Text("저장")
                    }
                    .foregroundStyle(starBool ? .blue : .gray)
                }
            }
            .frame(maxWidth: .infinity)
            //            .border(.blue)
            Divider()
                .frame(height: 64)
            VStack {
                ShareLink(item:  URL(string: information.informationURL)!) {
                    VStack(spacing: 5){
                        
                        Image(systemName: "square.and.arrow.up")
                        Text("공유")
                    }
                }
            }
            .frame(maxWidth: .infinity)
            //            .border(.brown)
        }
        
        .foregroundStyle(.gray)
        //        .border(.pink)
    }
    func makePhoneCall() {
        if let phoneURL = URL(string: "tel://\(information.telephone.replacingOccurrences(of: "-", with:""))"), UIApplication.shared.canOpenURL(phoneURL) {
            UIApplication.shared.open(phoneURL)
        }

        
    }
    
}




//#Preview {
//    DetailView(information: Row(gubun: "구분", serviceID: "아이디", maxClass: "큰클래스", minClass: "작은클래스", serviceStatus: "상태", serviceName: "네임", payment: "ㄷ돈", placeName: "", userTarget: "1", informationURL: "1", locationX: "1", locationY: "1", serviceStartDate: "1", serviceEndDate: "1", registerStartDate: "1", registerEndDate: "1", areaName: "1", imageURL: "https://yeyak.seoul.go.kr/web/common/file/FileDown.do?file_id=1699407981833BDABH9JL28HPGSME2RMXBEFMX"))
//}

//BannerView()
//    .frame(width: 320, height: 50)
//    .border(.black)




//저장되면 토스트 메세지 "저장되었습니다"
