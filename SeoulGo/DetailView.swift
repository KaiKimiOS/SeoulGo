//
//  DetailView.swift
//  SeoulGo
//
//  Created by kaikim on 1/9/24.
//

import SwiftUI
import NMapsMap

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
        
        VStack{
            NaverMap(y: locationY, x: locationX)
                .aspectRatio(contentMode: .fit)
            
            Text("hihi")
            Text("\(information.placeName)")
            
            AsyncImage(url: uuuu) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            
            Text("\(information.placeName)")
            
            Text("\(information.gubun)")
            
            
        }
        .navigationTitle(information.serviceName)
        .navigationBarTitleDisplayMode(.inline)

    }
    
}

