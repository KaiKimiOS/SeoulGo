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

struct DetailView:View {
    @State var starBool:Bool = false
    @State var isWebViewBool: Bool = false
    @StateObject var coordinator : Coordinator = Coordinator.shared
    
    var information:Row
    
    var imageURL: URL? {
        URL(string: information.imageURL)
    }
    
    var locationY: Double {
        guard let locationY = Double(information.locationY) else { return 0 }
        return locationY
    }
    
    var locationX: Double {
        guard let locationX = Double(information.locationX) else { return 0 }
        return locationX
    }
    var star:String {
        
        starBool ? "star.fill" : "star"
        
    }
    
    var body: some View {
        ScrollView{
            VStack{
                
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .clipShape(.rect)
                        .aspectRatio(16/9, contentMode: .fit)
                        //.border(.white)
                        .padding(5)
                    
                } placeholder: {
                    ProgressView()
                }
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
//                    WebKit(webURL: information.informationURL)
                    SFSafariView(url: information.informationURL)
                })
                
                VStack {
                    NaverMap(x: locationX, y: locationY)
                        .aspectRatio(1.0, contentMode: .fit)

                        .padding(5)
                }
                .padding()
                
                
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
                if UserDefaults.shared.value(forKey: "\(information.serviceID)") as? String ?? "" == information.serviceID {
                   
                    starBool = true
                } else {
                    starBool = false
                }
            }

            .navigationTitle(information.serviceName)
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
    
    
}




//#Preview {
//    DetailView(information: Row(gubun: "구분", serviceID: "아이디", maxClass: "큰클래스", minClass: "작은클래스", serviceStatus: "상태", serviceName: "네임", payment: "ㄷ돈", placeName: "", userTarget: "1", informationURL: "1", locationX: "1", locationY: "1", serviceStartDate: "1", serviceEndDate: "1", registerStartDate: "1", registerEndDate: "1", areaName: "1", imageURL: "https://yeyak.seoul.go.kr/web/common/file/FileDown.do?file_id=1699407981833BDABH9JL28HPGSME2RMXBEFMX"))
//}

