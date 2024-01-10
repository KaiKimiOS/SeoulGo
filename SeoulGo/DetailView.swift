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
//            
//            AsyncImage(url: uuuu) { image in
//                image
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//            } placeholder: {
//                ProgressView()
            }
            Text("hihi")
            Text("\(information.placeName)")
            Text("hihi")
            Text("\(information.gubun)")
        
        
        .navigationTitle(information.serviceName)
    }
    //    func imageU(url:String) {
    //        do{
    //            let url = URL(string: url)
    //            let data = try Data(contentsOf: url!)
    //            let image1 = UIImage(data: data)
    //
    //        } catch{
    //            print(error.localizedDescription)
    //        }
    //    }

    
    
    
}



