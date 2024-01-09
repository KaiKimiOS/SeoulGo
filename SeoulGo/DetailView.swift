//
//  DetailView.swift
//  SeoulGo
//
//  Created by kaikim on 1/9/24.
//

import SwiftUI


struct DetailView:View {
    
    var information:Row
    var uuuu: URL? {
        URL(string: information.imageURL)
    }
    
    
    
    var body: some View {
        
        VStack{
            
            Text("hihi")
            Text("\(information.placeName)")
            
            AsyncImage(url: uuuu) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView()
            }
            Text("hihi")
            Text("\(information.placeName)")
            Text("hihi")
            Text("\(information.placeName)")
        }
        
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



