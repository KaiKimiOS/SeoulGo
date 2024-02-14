//
//  Store.swift
//  SeoulGo
//
//  Created by kaikim on 1/26/24.
//

import Foundation

@MainActor
class Store: ObservableObject {
    
    @Published var storeManager:[Row] = []
    @Published var favoriteLists:[Row] = []
    //@Published var selectedResults:[Row] = []
    @Published var allSports:[String] = []
    @Published var allArea:[AreaName] = []
    
    // section에서 같은 지역을 한꺼번에 묶어서 화면에 보여주기 위해서.
    @Published var areaDictionary:[String: [Row]] = [:]
    
    //Network Fetch 하는 함수
    func fetchRequest() async-> [Row] {
        let tempStore = await Network.getData()
        guard let row = tempStore.first else {
            return [] }
        storeManager = row.ListPublicReservationSport.resultDetails
        return storeManager
    }
    
    func getSelectedSports() {
        allSports = storeManager.map({ $0.minClass })
    }
    
    //HomeView에서 체육종목 선택 완료후 지역정보 보여주기
    func getSelectedArea(sport:String) -> [Row]{
       
        if sport == "전체종목" {
            return storeManager
        }
        let selectedArea = storeManager.filter{ $0.minClass == sport}
        let selectedArea2 = selectedArea.map {$0.areaName}
        let allCasesAreas: [AreaName] = AreaName.allCases.map { $0 }
        let tempArea = Array(Set(selectedArea2)).sorted(by: <)
        
        for i in allCasesAreas {
            if tempArea.contains(i.rawValue) {
                allArea.append(i)
            }
        }
        
        return selectedArea
    }
    
    //HomeView에서 체육종목,지역 선택 완료한 체육시설 정보 보여주기
    func getSelectedResults(sport:String, areaName:String) -> [Row] {
       
     
        if sport == "전체종목" && areaName != "전체지역" {
            return storeManager.filter { $0.areaName == areaName }
        } else {
           return storeManager.filter { $0.minClass == sport && $0.areaName == areaName }
        }
    }
    
    //FavoriteView , UserDefaults.shared에 저장되어있는 값 가져오기
    func putUserDefaultsToLists() {
        
        favoriteLists = storeManager.filter { row in
            UserDefaults.shared.dictionaryRepresentation().keys.contains(row.serviceID)
        }
    }
    
    //FavoriteView, Dictionary해서 Area 묶어서 보여주기
    func putlistToDictionary() {
        
        areaDictionary = Dictionary(grouping: favoriteLists){ $0.areaName }
        // network.favoriteLists를 $0.areaName을 키값으로 해서 그룹핑해준다.
    }
    
}
