//
//  FavoriteView.swift
//  SeoulGo
//
//  Created by kaikim on 1/12/24.
//

import SwiftUI

struct FavoriteView: View {
    
    @EnvironmentObject var store:Store
    @State var areaDictionary:[String: [Row]] = [:] // section에서 같은 지역을 한꺼번에 묶어서 화면에 보여주기 위해서.
    
    var areaKey:[String] { //key를 리턴해서, ForEach에서 키값으로 Section을 구분해주고, ForEach에서 areaDictionary[areaKey]를 통해 키값에 맞는 value를 보여준다
        areaDictionary.map{$0.key}.sorted(by: <)
    }
    var star = "star.fill"
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    
                    if store.favoriteLists.isEmpty { Text("좋아하는 종목과 구장을 저장해보세요") } else {
                        
                        ForEach(areaKey, id:\.self) { areaName in
                            Section(areaName) {
                                ForEach(areaDictionary[areaName]!, id:\.serviceID) { information in
                                    HStack {
                                        VStack{
                                            Button {
                                                UserDefaults.shared.removeObject(forKey: information.serviceID)
                                            } label: {
                                                Image(systemName: star)
                                            }
                                            .buttonStyle(.borderless)
                                        }
                                        
                                        
                                        VStack{
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
            }
            .onAppear {
                
                putUserDefaultsToLists()
                putlistToDictionary()
                
            }
            .refreshable {
                putUserDefaultsToLists()
                putlistToDictionary()
            }
            .onChange(of:UserDefaults.shared.dictionaryRepresentation().keys) { _ in
                putUserDefaultsToLists()
                putlistToDictionary()
            }
        }
    }
    
    func putUserDefaultsToLists() {
        
        
        store.favoriteLists =
                store.storeManager.filter { row in
                    UserDefaults.shared.dictionaryRepresentation().keys.contains(row.serviceID)
                    //                    && !network.favoriteLists!.contains(where:{ $0.serviceID == row.serviceID })
                }
        
    }
    
    func putlistToDictionary() {
        
        areaDictionary.removeAll()
        areaDictionary = Dictionary(grouping: store.favoriteLists){ $0.areaName } // network.favoriteLists를 $0.areaName을 키값으로 해서 그룹핑해준다.
        
        //        for i in network.favoriteLists! {
        //
        //            let areaName = i.areaName
        //            areaDictionary[areaName] = areaDictionary[areaName] ?? []
        //            areaDictionary[areaName]!.append(i)
        //
        //
        //        }
        //        print("이거는 📖 \(areaDictionary)")
    }
}





#Preview {
    ContentView()
}
