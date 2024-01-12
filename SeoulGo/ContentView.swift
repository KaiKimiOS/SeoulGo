//
//  ContentView.swift
//  SeoulGo
//
//  Created by kaikim on 12/30/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    var body: some View {
        TabView{
            
            
            HomeView()
                .tabItem { Image(systemName: "house")
                    Text("home")
                }
            FavoriteView()
                .tabItem { Image(systemName: "star")
                 
                        
                    Text("즐겨찾기")
                }
            tempView()
                .tabItem { Image(systemName: "star")
                 
                        
                    Text("즐겨찾기")
                }
            
        }
  
    }
}

#Preview {
    ContentView()
    
}
