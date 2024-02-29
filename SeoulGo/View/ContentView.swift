//
//  ContentView.swift
//  SeoulGo
//
//  Created by kaikim on 12/30/23.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var store:Store
    
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
            }
        
    }
    
}

#Preview {
    ContentView()
    
}
