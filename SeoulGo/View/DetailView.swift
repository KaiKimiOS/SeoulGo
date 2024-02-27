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
        ScrollView{
            
            VStack{
                
                BannerView()
                    .frame(width: 320, height: 50)
                    .border(.black)
                
                Divider()
 
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .clipShape(.buttonBorder)
                        .frame(width: 380, height: 250)
                        //.aspectRatio(16/9, contentMode: .fit)
                    //.border(.white)
                    
                } placeholder: {
                    ProgressView()
                }
                Divider()
                VStack(spacing:10){
                    
                    HStack {
                        Text("\(information.areaName)" + " - \(information.placeName)")
                            .modifier(detailMoidifier())
                        
                    }
                    HStack{
                        
                        Text("\(information.serviceStatus)")
                            .modifier(detailMoidifier())
                        Text("\(information.payment)")
                            .modifier(detailMoidifier())
                        
                    }
                    
                    HStack{
                        
                        Text("접수기간: \(information.registerStartDate)" + " ~ \(information.registerEndDate)" )
                            .font(.subheadline)
                            .modifier(detailMoidifier())
                    }
                    HStack{
                        Text("이용기간: \(information.serviceStartDate)" + " ~ \(information.serviceEndDate)" )
                            .font(.subheadline)
                            .modifier(detailMoidifier())
                    }
                    
                    
                }
                .padding(5)
                
                Button(action: {
                    isWebViewBool = true
                }, label: {
                    HStack{
                        Spacer()
                        Text("예약하기")
                        Spacer()
                        
                    }
                    .padding()
                    
                })
                .buttonStyle(.borderedProminent)
                .padding([.leading,.trailing,.bottom], 5)
                
                .sheet(isPresented: $isWebViewBool, content: {
                    SFSafariView(url: information.informationURL)
                })
                
                VStack {
                    ZStack(alignment:.topTrailing) {
                        
                        
                        if isNaverMapBool {
                            NaverMapWithSnapShot(x: locationX, y: locationY)
//                                .modifier(detailMoidifier())
                                .frame(width: 380, height: 200)
                                .clipShape(.buttonBorder)
                                //.aspectRatio(1.0, contentMode: .fit)
                                .border(.black)
                                
                        }
                        
                        
                        
                        NavigationLink{
                            
                            NaverMapWithNavigationLink(x: locationX, y: locationY)
                            
                            
                        } label: {
                            Image(systemName: "arrow.down.backward.and.arrow.up.forward.square.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundStyle(Color.gray)
                                .frame(width: 30, height: 30)
                                .padding(10)
                            
                        }
                    }
                    
                }
                
                
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("즐겨찾기", systemImage: star) {
                        starBool.toggle()
                        starBool ?  UserDefaults.shared.setValue(information.serviceID, forKey: information.serviceID) :
                        UserDefaults.shared.removeObject(forKey: information.serviceID)
                        WidgetCenter.shared.reloadAllTimelines()
                    }
                    
                }
                
            })
            
            .onAppear{
                
                isNaverMapBool = true
                if UserDefaults.shared.value(forKey: "\(information.serviceID)") as? String ?? "" == information.serviceID {
                    
                    starBool = true
                } else {
                    starBool = false
                }
                
            }
            .onDisappear(perform: {
                isNaverMapBool = false
            })
            
            .navigationTitle(information.serviceName)
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
    
    
}




//#Preview {
//    DetailView(information: Row(gubun: "구분", serviceID: "아이디", maxClass: "큰클래스", minClass: "작은클래스", serviceStatus: "상태", serviceName: "네임", payment: "ㄷ돈", placeName: "", userTarget: "1", informationURL: "1", locationX: "1", locationY: "1", serviceStartDate: "1", serviceEndDate: "1", registerStartDate: "1", registerEndDate: "1", areaName: "1", imageURL: "https://yeyak.seoul.go.kr/web/common/file/FileDown.do?file_id=1699407981833BDABH9JL28HPGSME2RMXBEFMX"))
//}

