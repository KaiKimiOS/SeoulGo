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

struct DetailView:View {
    
    var information:Row
    var uuuu: URL? {
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
    
    
    var body: some View {
        ScrollView{
            VStack{
                
                AsyncImage(url: uuuu) { image in
                    image
                        .resizable()
                        .clipShape(.rect)
                        .aspectRatio(16/9,contentMode: .fit)
                        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 5)
                    
                } placeholder: {
                    ProgressView()
                }
                VStack(spacing:10){
                    HStack{
                        
                        Text("\(information.serviceStatus)")
                            .modifier(detailMoidifier())
                        Text("\(information.payment)")
                            .modifier(detailMoidifier())
                        
                    }
                    
                    HStack{
                        
                        Text("접수기간: \(information.registerStartDate.stringToDate())" + " ~ \(information.registerEndDate.stringToDate())" )
                            .font(.subheadline)
                            .modifier(detailMoidifier())
                    }
                    HStack{
                        Text("이용기간: \(information.serviceStartDate.stringToDate())" + " ~ \(information.serviceEndDate.stringToDate())" )
                            .font(.subheadline)
                            .modifier(detailMoidifier())
                    }
                    HStack {
                        Text("\(information.areaName)" + " - \(information.placeName)")
                            .modifier(detailMoidifier())
                        
                    }
                }
                //                .border(Color.black)
                .padding(5)
                
                NavigationLink("예약예약WEBkit") {
                    WebKit(webURL: information.informationURL)
                }
                
                NavigationLink("예약예약SF") {
                    SFSafariView(url: information.informationURL)
                }
                
                Button(action: {
                    //print(information.registerEndDate.stringToDate())
                    print("예약하기")
                    print(information.registerEndDate)
                    print(information.serviceEndDate)
                    WebKit(webURL: information.informationURL)
                }, label: {
                    Text("예약하기")
                })
                NaverMap(y: locationY, x: locationX)
                
                    .aspectRatio(16/9, contentMode: .fit)
                    .border(Color.white, width: 5)
                
                
                
            }
            .navigationTitle(information.serviceName)
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
    
    
}




//#Preview {
//    DetailView(information: Row(gubun: "구분", serviceID: "아이디", maxClass: "큰클래스", minClass: "작은클래스", serviceStatus: "상태", serviceName: "네임", payment: "ㄷ돈", placeName: "", userTarget: "1", informationURL: "1", locationX: "1", locationY: "1", serviceStartDate: "1", serviceEndDate: "1", registerStartDate: "1", registerEndDate: "1", areaName: "1", imageURL: "https://yeyak.seoul.go.kr/web/common/file/FileDown.do?file_id=1699407981833BDABH9JL28HPGSME2RMXBEFMX"))
//}

