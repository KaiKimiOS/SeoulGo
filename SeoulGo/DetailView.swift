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
//                        .aspectRatio(contentMode: .fit)
                        .scaledToFit()
                        .frame(minWidth: 200,  maxWidth:.infinity, idealHeight: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                      
                } placeholder: {
                    ProgressView()
                }
                
                Text("\(information.placeName)")
                
                Text("\(information.gubun)")
                
                NavigationLink("예약예약WEBkit") {
                    WebKit(webURL: information.informationURL)
                }
                NavigationLink("예약예약SF") {
                    SFSafariView(url: information.informationURL)
                }
                Button(action: {
                    print("예약하기")
                    print(information.informationURL)
                    WebKit(webURL: information.informationURL)
                }, label: {
                    Text("예약하기")
                })
                
                NaverMap(y: locationY, x: locationX)
                    .aspectRatio(contentMode: .fit)
//                    .scaledToFit()
                    .frame(minWidth: 200,  maxWidth:.infinity, maxHeight: .infinity, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)

                
                
            }
            .navigationTitle(information.serviceName)
            .navigationBarTitleDisplayMode(.inline)
        }

    }
    
}

#Preview {
    HomeView()
}
