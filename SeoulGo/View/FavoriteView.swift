//
//  FavoriteView.swift
//  SeoulGo
//
//  Created by kaikim on 1/12/24.
//

import SwiftUI
import GoogleMobileAds
import WidgetKit

struct FavoriteView: View {
    
    @EnvironmentObject var store:Store
    @State var star = "star.fill"
    //key를 리턴해서, ForEach에서 키값으로 Section을 구분해주고, ForEach에서 areaDictionary[areaKey]를 통해 키값에 맞는 value를 보여준다
    var areaKey:[String] { store.areaDictionary.map{$0.key}.sorted(by: <)  }
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    
                    if store.favoriteLists.isEmpty { Text("좋아하는 종목과 구장을 저장해보세요") } else {
                        
                        ForEach(areaKey, id:\.self) { areaName in
                            Section(areaName) {
                                ForEach(store.areaDictionary[areaName]!, id:\.serviceID) { information in
                                    HStack {
                                        VStack {
                                            Button {
                                                UserDefaults.shared.removeObject(forKey: information.serviceID)
                                                WidgetCenter.shared.reloadAllTimelines()
                                                
                                            } label: {
                                                Image(systemName: star)
                                            }
                                            .buttonStyle(.borderless)
                                        }
                                        VStack {
                                            NavigationLink("\(information.serviceName)") {
                                                DetailView(information: information)
                                            }
                                        }
                                        
                                    }
                                    
                                }
                                
                                
                            }
                        }
                        
                        
                    }
                }
                GoogleBanner()
                    .frame(width: 320, height: 50)
                    .border(.black)
            }
            .navigationTitle("즐겨찾기")
            .navigationBarTitleDisplayMode(.inline)
            
            .onAppear {
                store.putUserDefaultsToLists()
                store.putlistToDictionary()
            }
            .refreshable {
                store.putUserDefaultsToLists()
                store.putlistToDictionary()
            }
            
        }
    }
}

#Preview {
    ContentView()
}
