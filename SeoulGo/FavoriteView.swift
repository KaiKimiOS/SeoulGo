//
//  FavoriteView.swift
//  SeoulGo
//
//  Created by kaikim on 1/12/24.
//

import SwiftUI

struct FavoriteView: View {
  
    @EnvironmentObject var network: Network
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("gg")
                Text("\(network.favoriteLists.count)")
  
                }
            }
        }
    }


#Preview {
    FavoriteView()
}
