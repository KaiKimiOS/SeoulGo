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
    //즐겨찾기
    
    @State var isWebViewBool: Bool = false
    @Binding var information:Row
    @EnvironmentObject var network: Network
    //@AppStorage("clicked") private var count:String = ""
    

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
    @State var starBool:Bool = false
    var star:String {
        
        information.star ? "star.fill" : "star"
        
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
                        
                        Text("접수기간: \(information.registerStartDate.stringToDate())" + " ~ \(information.registerEndDate.stringToDate())" )
                            .font(.subheadline)
                            .modifier(detailMoidifier())
                    }
                    HStack{
                        Text("이용기간: \(information.serviceStartDate.stringToDate())" + " ~ \(information.serviceEndDate.stringToDate())" )
                            .font(.subheadline)
                            .modifier(detailMoidifier())
                    }
                    
                }
                .padding(5)
                
                Button(action: {
                    print(star)
//                    information.star.toggle()
//                    UserDefaults.standard.setValue(information.serviceID, forKey: information.serviceID)
//                    count = information.serviceID
//                    isWebViewBool = true
                }, label: {
                    HStack{
                        Spacer()
                        Text("예약하기")
                        Spacer()
                            
                    }
                    .padding()
//
//                    .modifier(detailMoidifier())
//                    .padding([.leading,.trailing,.bottom], 5)
                })
                .buttonStyle(.borderedProminent)
                .padding([.leading,.trailing,.bottom], 5)
                
                .sheet(isPresented: $isWebViewBool, content: {
                    WebKit(webURL: information.informationURL)
                    //SFSafariView(url: information.informationURL)
                })
                
                NaverMap(y: locationY, x: locationX)
                    .aspectRatio(1.0, contentMode: .fit)
                    //.border(Color.white)
                    .padding(5)
                
                
                
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("즐겨찾기", systemImage: star) {
                        information.star.toggle()
                        information.star ?  UserDefaults.standard.setValue(information.serviceID, forKey: information.serviceID) : UserDefaults.standard.removeObject(forKey: information.serviceID)
                        information.star ? network.favoriteLists.append(information) : network.favoriteLists.removeAll(where: { $0.serviceID == information.serviceID
                        })
                        print(information.star)
                    }
                }
            })
            .onAppear{
             
                if UserDefaults.standard.value(forKey: "\(information.serviceID)") as? String ?? "" == information.serviceID {
                    information.star = true
                } else {
                    information.star = false
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

